/**
 * PinePG Payment Gateway - WooCommerce Blocks Integration
 */
(function () {
    var el = window.wp.element.createElement;
    var registerPaymentMethod = window.wc.wcBlocksRegistry.registerPaymentMethod;
    var settings = window.wc.wcSettings.getSetting('pinepg_data');

    registerPaymentMethod({
        name: 'pinepg',
        label: el('span', null, settings.title),
        content: el('div', null),
        edit: el('div', null),
        canMakePayment: function () { return true; },
        ariaLabel: settings.title,
        supports: settings
    });
})();