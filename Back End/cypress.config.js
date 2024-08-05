const { defineConfig } = require("cypress");

module.exports = defineConfig({
  projectId: 't939o4',
  e2e: {
    setupNodeEvents(on, config) {
      // implement node event listeners here
    },
    "supportFile": false
  },
});
