describe('API Tests', () => {
  const apiUrl = 'LAMBDA_FUNCTION_URL';

  it('should update the database', () => {
    let initialCounter;

    // Initial POST request to fetch the current counter value
    cy.request({
      method: 'POST',
      url: apiUrl,
      body: JSON.stringify({ tableName: "DYNAMODB_TABLE_NAME" }),
      headers: {
        'Content-Type': 'application/json'
      }
    }).then((response) => {
      initialCounter = parseInt(response.body, 10);
      cy.log('Initial Counter:', initialCounter);

      // POST request to increment the counter
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
    }).catch((error) => {
      // Handle any errors that occur during the requests
      cy.log('Error:', error);
      throw error;
    });
  });
});