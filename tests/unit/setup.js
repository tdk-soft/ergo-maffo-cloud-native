// Test setup for unit tests
process.env.NODE_ENV = "test";
process.env.PORT = 3001;

// Global test timeout
jest.setTimeout(10000);

// Mock console.error to fail tests
const originalError = console.error;
console.error = (...args) => {
  originalError(...args);
  throw new Error("Console.error called in test: " + args.join(" "));
};

// Cleanup after each test
afterEach(() => {
  jest.clearAllMocks();
  jest.resetModules();
});
