"use strict";

/*
 * This code is run on every page matching the content_scripts matches setting in the manifest.json.  For Hackathon,
 * this was set to be any amazon.com page.
 *
 * The first part of the code, related to the "add-to-cart-button" is run on an item page (which has an Add to Cart
 * button on it).  That code extracts the category from some of the information about the item.  That is saved in
 * localStorage for use when we are on the "added to cart" page.
 *
 * The rest of the code is looking for the "proceed to checkout" button, which means we're on the "added to cart" page,
 * that is, the user looked at an item and then added it to the cart.  It is on this page that we want to extract
 * the item price and get the budget for the category and then warn they user if they are about to exceed their
 * budget.
 */

var budgetLeft = 50;

var budgetsLeft = {
    "Electronics": 25.0,
    "Clothing": 75.0
};

var mintBaseUrl = "https://stage.mint.com/";

// Get the category for later
if ($('#add-to-cart-button').length > 0) {
    // We're on a product page, get the category
    var category = $('#SalesRank').eq(0).text();
    var inLoc = category.indexOf(' in ') + 4;
    var catEnd = category.indexOf(' ', inLoc);
    category = category.substring(inLoc, catEnd);
    console.log('category: ' + category);
    localStorage.setItem("mintAdvisorCategory", category);
}


var prices = [];
$('.hlb-item-stats>.hlb-price').each(function() {
    prices.push($(this).text().trim());
});

var $checkoutButton = $('.hlb-checkout-button');

$('<div id="mintBudgetAlert"></div>').appendTo('body');
var $popup = $('#mintBudgetAlert');

console.log(localStorage.getItem('mintAdvisorCategory'));

if ($checkoutButton.length && prices.length) {
    var itemName = $('.hlb-item-link').text();
    var itemPrice = parseFloat(prices[0].replace('$', '')).toFixed(2);
    var budgetLeftValue = budgetLeft;

    var categoryStr = '';
    var savedCategory = localStorage.getItem('mintAdvisorCategory');
    if (savedCategory != false) {
        switch (savedCategory.toLowerCase()) {
            case 'shoes':
                savedCategory = 'Clothing';
        }
        categoryStr = ' for <b>' + savedCategory + '</b>';
        if (savedCategory in budgetsLeft) {
            budgetLeftValue = budgetsLeft[savedCategory];
        }
    }
    var amountExceedingBudget = (itemPrice - budgetLeftValue).toFixed(2);
    if (amountExceedingBudget > 0) {
        $popup.append('<h1>Oops!</h1>\n' +
            '<a id="closeMintBudgetAlert" href="#"></a>\n' +

            'This item puts you <b>$' + amountExceedingBudget + '</b> over budget' + categoryStr + '.\n' +

            '<div class="item">\n' +
            '    <b>$' + itemPrice + '</b>&nbsp; ' + itemName.trim() + '\n' +
            '</div>\n' +

            'Are you sure you need this now?\n' +

            '<ul>\n' +
            '    <li>I guess not. Create a <a href="' + mintBaseUrl + 'goal.event" target="_blank">savings plan</a> on Mint</li>\n' +
            '    <li>Yes. <a href="' + mintBaseUrl + 'planning.event" target="_blank">Adjust my budget</a> on Mint</li>\n' +
            '    <li><a href="#" id="mintAdvisorClose">Go away</a>. I know what I\'m doing!</li>\n' +
            '</ul>\n' +

            '<div class="mintBranding"></div>\n');

        $popup.css('left', $checkoutButton.offset().left - ($popup.width()/2) + 220).css('top', $checkoutButton.offset().top - ($popup.height()/2));
        $popup.show();

        $('#mintAdvisorClose,#closeMintBudgetAlert').on('click', function() {
            $('#mintBudgetAlert').hide();
        });
    }
}

