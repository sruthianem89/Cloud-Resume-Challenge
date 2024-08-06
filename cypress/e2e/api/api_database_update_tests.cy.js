describe('API Tests', () => {
    const apiUrl = 'https://ufzbpvnwxu3idxfbhczvwftxoi0xtkux.lambda-url.us-east-1.on.aws/';
  
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
  