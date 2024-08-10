// cypress/e2e/api/verify_visitor_count.cy.js

describe('Web Tests', () => {
  const resumeUrl = 'WEBSITE_URL'; // Replace with your actual resume URL
  const resetUrl = 'RESET_FUNCTION_URL'; // Replace with your actual reset URL

  it('should display the visitor count in the DOM and not show an error message', () => {
    // Visit the resume page
    cy.visit(resumeUrl);

    // Wait for the visitor count to be updated and ensure it's not an error message
    cy.get('#count-value', { timeout: 10000 }) // Adjust the timeout if needed
      .should(($countValue) => {
        // Ensure that the count value is not the error message
        const text = $countValue.text().trim();
        expect(text).to.not.equal('Error loading count value');
      });

    // Call the reset URL with the DynamoDB table name in the body
    cy.request({
      method: 'POST',
      url: resetUrl,
      body: {
        tableName: "DYNAMODB_TABLE_NAME" // Replace with your actual DynamoDB table name
      },
      headers: {
        'Content-Type': 'application/json'
      }
    }).then((response) => {
      expect(response.status).to.equal(200);
    });
  });
});