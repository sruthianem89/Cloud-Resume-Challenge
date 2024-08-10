describe('API Tests', () => {
  const apiUrl = 'LAMBDA_FUNCTION_URL';

  it('should update the database', () => {
    let initialCounter;

    // Initial GET request to fetch the current counter value
    cy.request({
      method: 'POST',
      url: apiUrl,
      body: JSON.stringify({ tableName: "DYNAMODB_TABLE_NAME" }),
      headers: {
        'Content-Type': 'application/json'
      }
    }).then((response) => {
      initialCounter = parseInt(response.body, 10);

      // POST request to increment the counter
      return cy.request({
        method: 'POST',
        url: apiUrl,
        body: JSON.stringify({ tableName: "DYNAMODB_TABLE_NAME" }),
        headers: {
          'Content-Type': 'application/json'
        }
      });
    }).then(() => {
      // GET request to fetch the updated counter value
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
      expect(updatedCounter).to.eq(initialCounter + 1);
    });
  });
});