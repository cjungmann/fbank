# Family Bank Project

Technically, this is a repository for a simple allowance system
for a family.  However, its greater purpose is to be a place to
work on a couple of ideas that have wider application.

At the writing of this README file, the two ideas I'm developing:
1. **sublines**
2. **two-way**

The **sublines** input element if for associating one or more
subordinate records with a given reference element.  In this
case, a transaction is modeled after a general ledger transaction
that may may have one or several constituent actions.  With the
**sublines** input element, the collection of actions are built
up and submitted to **schema.fcgi** at one time.

The **two-way** input element is a toggle switch between two
values.  The element is backed by a checkbox input element.
For this application, the toggle is between a *debit* or *credit*
action.

## Resources

I am looking for some implementation ideas.  I am aware of the
toggle switch tension that showing the current state on the element
is in may confuse a user who sees the label as advertising the
ability to change to the indicated state.  In other words, a
toggle button that says "On" may be indicating that the switch
is on, or that pressing the button will turn the switch on.

[CSS-only toggle switch implementation](https://codepen.io/AndrewGehman/pen/yORbev)

[w3schools example.  I'm using some of this.](https://www.w3schools.com/howto/howto_css_custom_checkbox.asp)
