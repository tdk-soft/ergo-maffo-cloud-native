#!/bin/bash

# Script de déploiement pour l'environnement de développement
# Usage: ./scripts/deploy-dev.sh [--rebuild] [--logs]

set -euo pipefail

# Couleurs pour les logs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
NAMESPACE="ergo-development"
DEPLOYMENT_NAME="ergo-site"
KUSTOMIZE_PATH="k8s/overlays/development"
REBUILD=false
SHOW_LOGS=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --rebuild)
            REBUILD=true
            shift
            ;;
        --logs)
            SHOW_LOGS=true
            shift
            ;;
        --help)
            echo "Usage: $0 [--rebuild] [--logs]"
            echo "  --rebuild: Rebuild and push Docker image before deploy"
            echo "  --logs:    Show logs after deployment"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

# Fonctions de logging
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Vérification des prérequis
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    command -v kubectl >/dev/null 2>&1 || { log_error "kubectl is required but not installed"; exit 1; }
    command -v kustomize >/dev/null 2>&1 || { log_error "kustomize is required but not installed"; exit 1; }
    command -v docker >/dev/null 2>&1 || { log_warning "docker not found. Skipping rebuild option."; REBUILD=false; }
    
    # Vérifier la connexion au cluster
    kubectl cluster-info >/dev/null 2>&1 || { log_error "Cannot connect to Kubernetes cluster"; exit 1; }
    
    log_success "Prerequisites OK"
}

# Rebuild Docker image (optionnel)
rebuild_image() {
    if [ "$REBUILD" = true ]; then
        log_info "Rebuilding Docker image..."
        
        # Login to GHCR
        echo "$GH_PAT" | docker login ghcr.io -u "$GITHUB_ACTOR" --password-stdin
        
        # Build and push
        IMAGE="ghcr.io/tdk-soft/ergo-maffo-cloud-native/ergo-site:dev-$(git rev-parse --short HEAD)"
        docker build -t "$IMAGE" .
        docker push "$IMAGE"
        
        # Update kustomize image
        cd "$KUSTOMIZE_PATH" || exit
        kustomize edit set image "ghcr.io/tdk-soft/ergo-maffo-cloud-native/ergo-site=$IMAGE"
        cd - || exit
        
        log_success "Image rebuilt and pushed: $IMAGE"
    fi
}

# Créer le namespace s'il n'existe pas
create_namespace() {
    log_info "Ensuring namespace exists..."
    
    if ! kubectl get namespace "$NAMESPACE" >/dev/null 2>&1; then
        kubectl create namespace "$NAMESPACE"
        log_success "Namespace $NAMESPACE created"
    else
        log_info "Namespace $NAMESPACE already exists"
    fi
}

# Ajouter des labels au namespace
label_namespace() {
    log_info "Adding labels to namespace..."
    
    kubectl label namespace "$NAMESPACE" \
        environment=development \
        managed-by=kustomize \
        --overwrite >/dev/null 2>&1
    
    log_success "Namespace labeled"
}

# Déployer avec kustomize
deploy() {
    log_info "Deploying to $NAMESPACE..."
    
    # Preview des changements
    log_info "Changes to be applied:"
    kustomize build "$KUSTOMIZE_PATH" | kubectl diff -f - --namespace="$NAMESPACE" || true
    
    # Appliquer la configuration
    kustomize build "$KUSTOMIZE_PATH" | kubectl apply -f -
    
    log_success "Deployment applied"
}

# Attendre le déploiement
wait_for_deployment() {
    log_info "Waiting for deployment to be ready..."
    
    kubectl wait --for=condition=available \
        --timeout=300s \
        "deployment/$DEPLOYMENT_NAME" \
        -n "$NAMESPACE"
    
    log_success "Deployment is ready"
}

# Vérifier le statut
check_status() {
    log_info "Checking deployment status..."
    
    # Pods
    echo -e "\n${YELLOW}Pods:${NC}"
    kubectl get pods -n "$NAMESPACE" -l app=ergo-site
    
    # Services
    echo -e "\n${YELLOW}Services:${NC}"
    kubectl get svc -n "$NAMESPACE"
    
    # Endpoints
    echo -e "\n${YELLOW}Endpoints:${NC}"
    kubectl get endpoints -n "$NAMESPACE"
    
    # Événements récents
    echo -e "\n${YELLOW}Recent events:${NC}"
    kubectl get events -n "$NAMESPACE" --sort-by='.lastTimestamp' | tail -10
}

# Health check
health_check() {
    log_info "Performing health check..."
    
    # Port-forward pour tester
    kubectl port-forward -n "$NAMESPACE" \
        "service/ergo-service" \
        30080:3000 >/dev/null 2>&1 &
    
    PF_PID=$!
    sleep 3
    
    # Tester l'endpoint health
    if curl -s -f "http://localhost:30080/health" >/dev/null; then
        log_success "Health check passed"
    else
        log_warning "Health check failed. Service may not be ready."
    fi
    
    # Nettoyer le port-forward
    kill $PF_PID 2>/dev/null || true
}

# Afficher les logs (optionnel)
show_logs() {
    if [ "$SHOW_LOGS" = true ]; then
        log_info "Showing logs (Ctrl+C to stop)..."
        kubectl logs -n "$NAMESPACE" \
            -l app=ergo-site \
            --tail=50 \
            --follow
    fi
}

# Fonction de rollback si nécessaire
rollback() {
    log_warning "Deployment failed. Rolling back..."
    
    kubectl rollout undo "deployment/$DEPLOYMENT_NAME" -n "$NAMESPACE"
    kubectl rollout status "deployment/$DEPLOYMENT_NAME" -n "$NAMESPACE" --timeout=60s
    
    log_success "Rollback completed"
}

# Main execution
main() {
    echo "========================================="
    echo "  Deploying to Development Environment"
    echo "========================================="
    echo ""
    
    check_prerequisites
    create_namespace
    label_namespace
    rebuild_image
    deploy
    
    # Tentative de déploiement avec rollback en cas d'échec
    if ! wait_for_deployment; then
        rollback
        exit 1
    fi
    
    check_status
    health_check
    
    echo ""
    log_success "Deployment complete!"
    echo ""
    echo "Access the application:"
    echo "  - Via NodePort: http://localhost:30080"
    echo "  - Debug port: localhost:30229"
    echo ""
    echo "Useful commands:"
    echo "  - View logs: kubectl logs -f -n $NAMESPACE -l app=ergo-site"
    echo "  - Exec into pod: kubectl exec -it -n $NAMESPACE deployment/$DEPLOYMENT_NAME -- /bin/sh"
    echo "  - Port forward: kubectl port-forward -n $NAMESPACE service/ergo-service 3000:3000"
    echo ""
    
    if [ "$SHOW_LOGS" = true ]; then
        show_logs
    fi
}

# Execution
main