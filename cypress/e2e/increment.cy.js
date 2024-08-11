describe('API Tests', () => {
  const apiUrl = 'LAMBDA_FUNCTION_URL';
  const resetUrl = 'RESET_FUNCTION_URL'; 

  it('should update the database', () => {
    let initialCounter;

    // Initial POST request to fetch the current counter value
    cy.request({
      method: 'POST',
      url: `${apiUrl}/getCounter`, 
      body: JSON.stringify({ tableName: "DYNAMODB_TABLE_NAME" }),
      headers: {
        'Content-Type': 'application/json'
      }
    }).then((response) => {
      initialCounter = parseInt(response.body, 10);
      cy.log('Initial Counter:', initialCounter);

      // POST request to increment the counter and get the updated counter value in the response
      return cy.request({
        method: 'POST',
        url: apiUrl,
        body: JSON.stringify({ tableName: "DYNAMODB_TABLE_NAME" }),
        headers: {
          'Content-Type': 'application/json'
        }
      });
    }).then((response) => {
      const updatedCounter = parseInt(response.body, 10);
      cy.log('Updated Counter:', updatedCounter);
      expect(updatedCounter).to.eq(initialCounter + 1);
    });

    // Handle any uncaught exceptions
    cy.on('uncaught:exception', (err, runnable) => {
      cy.log('Error:', err);
      return false; // Prevents Cypress from failing the test
    });
  });
});