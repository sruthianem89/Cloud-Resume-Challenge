describe('API Tests', () => {
    const apiUrl = 'https://cdoeemsrj7rh5qopepmez532gy0gcglf.lambda-url.us-east-1.on.aws/';
  
    it('should return correct status code and body', () => {
      cy.request(apiUrl).then((response) => {
        // Check the status code
        expect(response.status).to.eq(200);
  
        // Optionally log the response body for debugging
        console.log(response.body);
      });
    });
  });
  