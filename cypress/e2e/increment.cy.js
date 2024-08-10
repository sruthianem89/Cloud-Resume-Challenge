describe('API Tests', () => {
    const apiUrl = 'LAMBDA_FUNCTION_URL';
  
    it('should update the database', () => {
      let initialCounter;
      
      cy.request(apiUrl).then((response) => {
        initialCounter = parseInt(response.body, 10);
        return cy.request(apiUrl);
      }).then((response) => {
        const updatedCounter = parseInt(response.body, 10);
        expect(updatedCounter).to.eq(initialCounter + 1);
      });
    });
  });
  