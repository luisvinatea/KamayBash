KamayPWA Application
=====================

.. automodule:: KamayPWA
   :members:

KamayPWA is a tool designed to manage Progressive Web Apps (PWAs) from the command line.

Features
--------

*   Manages PWAs (details to be added).
*   Provides a desktop entry for easy launching via `kitty` terminal.

Setup
-----

The application includes a `setup.sh` script located in `apps/web/KamayPWA/` which handles:

1.  Checking for the `kitty` dependency.
2.  Copying the application icon to the user's local icon directory (`~/.local/share/icons`).
3.  Creating a `.desktop` file in the user's local application directory (`~/.local/share/applications`) for integration with desktop environments.

To install, navigate to the `apps/web/KamayPWA/` directory and run:

.. code-block:: bash

   bash setup.sh
