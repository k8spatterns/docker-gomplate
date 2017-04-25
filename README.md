<a href="https://leanpub.com/k8spatterns"><img src="https://s3.amazonaws.com/titlepages.leanpub.com/k8spatterns/hero?1492193906" align="right" width="300px" style="float:right; margin: 50px 30px 30px 30px;"/></a>

# Docker image for Gomplate 

This image build on top of [gomplate](https://github.com/hairyhenderson/gomplate). It adds support for bulk operation and is nicely fit for an init container to pre-process configuration files in a Kubernetes pod.

It is used in our upcoming [Kubernetes Patterns](https://leanpub.com/k8spatterns) book in examples for the [Configuration Template](https://github.com/k8spatterns/examples/tree/master/configuration/cm-template) pattern.

This image is typically used as a base image like in 

```Dockerfile
FROM k8spatterns/gomplate
COPY myconfig/ in/
CMD [ "--datasource", "/params", \
      "--input-dir",  "/in",     \
      "--output-dir", "/out" ]
```

The entry point is "gomplate" and can be configured in various. For our use case, where it is used as an init-container during application startup the following options are the most important.

* The `--input-dir` directory holds the templates. These are typically baked into the image like in this example.
* The `--datasource` is the directory holding the `gomplate` datasources. Each file in this directory is taken as an individual datasource which is used with the file's basename as key. E.g. a `config.yml` can be referenced from the template as `{{ (datasource "config").someKeyFromYamlFile }}`. This directory is typically mounted from the outside (e.g. from a Kubernetes `ConfigMap` backed volume).
* The `--output-dir` directory where to store the processed files. The generated files will have the same name as the input files. Only a flat directory is supported for the moment. This directory is typically also pointing to a directory within a volume so that the processed files can be used from the application to configure.
* Use `--chown <uid>:<gid>` for setting the ownership of the output files

For a full list of options use `docker run -it k8spatterns/gomplate -h`.

