
/**
 * Global Notification Utility
 * Dependencies: Toastify JS
 */
const Alert = {
    // Success Toast (Green)
    success: function(message) {
        this.show(message, "linear-gradient(135deg, #00b09b, #96c93d)");
    },

    // Error Toast (Red)
    error: function(message) {
        this.show(message, "linear-gradient(135deg, #ff5f6d, #ffc371)");
    },

    // Info/Warning Toast (Blue)
    info: function(message) {
        this.show(message, "linear-gradient(135deg, #2193b0, #6dd5ed)");
    },

    // Core function
    show: function(msg, bgColor) {
        Toastify({
            text: msg,
            duration: 3000,
            gravity: "top",
            position: "right",
            stopOnFocus: true,
            style: {
                background: bgColor,
                borderRadius: "12px",
                fontWeight: "600",
                boxShadow: "0 8px 15px rgba(0,0,0,0.3)"
            }
        }).showToast();
    }
};