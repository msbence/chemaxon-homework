# Clock mirror2real

*This is the first task of the ChemAxon homework.*

## Usage

The application is simple, and simple to use!

You just have to send a GET request in the following format: `/{hour}/{minute}`

This can be done in a simple web browser, or using CLI tools.

### Example

```bash
$ curl http://127.0.0.1:5000/12/35
11:25
```

## Build

There is a [Dockerfile](Dockerfile) available, therefore the build process is simple as that: `docker build -t clock-mirror2real .`

## Deployment

You can deploy the application whereever Docker engine can run.

My [Terraform configuration](tf) uses Amazon Web Services.
