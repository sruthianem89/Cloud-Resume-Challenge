describe('API Tests', () => {
    const apiUrl = 'INITIALIZE_FUNCTION_URL';
  
    it('should return correct status code and body', () => {
      cy.request(apiUrl).then((response) => {
        // Check the status code
        expect(response.status).to.eq(200);
  
        // Optionally log the response body for debugging
        console.log(response.body);
      });
    });
  });
  