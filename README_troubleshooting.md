# Troubleshooting

## Allowances Not Distributed

Truth be told, I have only one thing to add here, a solution
to an unexpected and undetected problem where the allowances
were not being distributed.

On the server hosting our family's bank, even though the
allowance event was scheduled, it was not occurring.  It turns
out that the global variable, **event_scheduler**, was OFF.

### Detect Problem

To test if that's the problem for which you consult this guide,
enter (at the command line):

~~~sh
$ mysql -e "select @@event_scheduler"
~~~

and note if the value is ON or OFF.

### Recommended Solution

The best thing in this situation, where the events will occur
indefintely, is to persistently enable event scheduling.  Do this
with a configuration line in the [mysqld] section:

~~~sh
event_scheduler = ON
~~~

With this setting enabled, MySQL will enable event scheduling
even after a reboot.

