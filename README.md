# Automated Virtual Test Network and VPN Setup using OpenVPN

This project was created as part of the *Betriebsystem und Rechnernetze* course at *Duale Hochschule Gera Eisenach*. The task was to astablish a site-to-site VPN conection betwen Virtual machines.

## Overview

The project aims to automate the creation of a virtual test network and streamline the setup process for a site-to-site VPN connection using OpenVPN. It demonstrates the automatic provisioning of virtual machines, network configurations, and the establishment of a secure VPN tunnel.

## Prerequisites

To replicate this project, ensure you have:
- VirtualBox installed on the host system
- Ubuntu/Kubuntu ISO images for automatic VM provisioning
- Basic scripting knowledge in bash

## Automated Setup Process

Refer to the `setup.md` file for detailed instructions on the automated setup process, including VM provisioning, OpenVPN installation, configuration automation, and validation steps.

## Contributing

We welcome contributions to improve and extend this project! Here's how you can contribute:

### Reporting Issues

If you encounter any bugs, issues, or have suggestions for improvements, please open an issue on the GitHub repository.

### Pull Requests

Feel free to fork this project and submit pull requests for enhancements, bug fixes, or new features. Ensure that your contributions align with the project's guidelines.

### Code of Conduct

Please review and adhere to our Code of Conduct when participating in this project. We aim to foster an inclusive and welcoming community.

# Repository Structure

This section outlines the structure of the project repository and provides an overview of the main directories and files within the project.

## Directory Structure

- `/Pictures`: Contains pictures for the `setup.md`.
- `/src`: Folder for subscripts which are caled in the main/central scripts and thurther configuration files.

## Files

- `README.md`: The main documentation file providing an overview of the project, setup instructions and contribution guidelines.
- `LICENSE`: Contains licensing information for the project.
- `setup.md`: Detailed instructions for setting up the virtual test network and configuring the VPN connection.
- Main/Central execution scripts.

## Troubleshooting

In case of issues during the automated setup or VPN connection:
- Check the script logs for error messages or warnings.
- Ensure correct network adapter configurations in VirtualBox.
- Verify the OpenVPN configuration files for accuracy in settings.

## Contributors

- [Your Name]
- [Other Group Members]

## License

This project is licensed under [License Name]. See the LICENSE file for details.

## Acknowledgments

Special thanks to [Professor's Name] for guidance and support during the course.
