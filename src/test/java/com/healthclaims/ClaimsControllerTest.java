package com.healthclaims;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class ClaimsControllerTest {

    // Create an instance of the controller to test
    ClaimsController controller = new ClaimsController();

    @Test
    void healthReturnsUp() {
        var result = controller.health();
        // assertEquals checks: is result.get("status") equal to "UP"?
        assertEquals("UP", result.get("status"));
    }

    @Test
    void getClaimReturnsCorrectStatus() {
        Claim c = controller.getClaim("CLM001");
        assertEquals("APPROVED", c.getStatus());
    }
}
