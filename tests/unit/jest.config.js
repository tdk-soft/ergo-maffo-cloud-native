module.exports = {
  testEnvironment: "node",
  roots: ["<rootDir>/tests/unit"],
  testMatch: ["**/__tests__/**/*.js", "**/?(*.)+(spec|test).js"],
  collectCoverageFrom: [
    "src/**/*.js",
    "!src/**/*.test.js",
    "!src/**/index.js",
  ],
  coverageThreshold: {
    global: {
      branches: 85,
      functions: 90,
      lines: 90,
      statements: 90,
    },
  },
  setupFilesAfterEnv: ["<rootDir>/tests/unit/setup.js"],
  moduleNameMapper: {
    "^@/(.*)$": "<rootDir>/src/$1",
  },
  reporters: [
    "default",
    ["jest-junit", {
      outputDirectory: "test-results/unit",
      outputName: "junit.xml",
    }],
  ],
};
