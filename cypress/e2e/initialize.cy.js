describe('API Tests', () => {
  const apiUrl = 'INITIALIZE_FUNCTION_URL';

  it('should return correct status code and body', () => {
    cy.request({
      method: 'POST',
      url: apiUrl,
      body: JSON.stringify({ tableName: "DYNAMODB_TABLE_NAME" }),
      headers: {
        'Content-Type': 'application/json'
      }
    }).then((response) => {
      // Check the status code
      expect(response.status).to.eq(200);

      // Optionally log the response body for debugging
      console.log(response.body);
    });
  });
});