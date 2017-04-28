<a href="https://leanpub.com/k8spatterns"><img src="https://s3.amazonaws.com/titlepages.leanpub.com/k8spatterns/hero?1492193906" align="right" width="300px" style="float:right; margin: 50px 30px 30px 30px;"/></a>

# Docker image for dynamic template processing

This image builds on top of a statically compiled [gomplate](https://github.com/hairyhenderson/gomplate) which uses `scratch` as base image (so it's quite small). It adds support for bulk operation and is a nicely fit for an init container to pre-process configuration files in a Kubernetes pod.

It is used in our [Kubernetes Patterns](https://leanpub.com/k8spatterns) book in examples for the [Configuration Template](https://github.com/k8spatterns/examples/tree/master/configuration/ConfigurationTemplate) pattern.

You use this image typically as a base image like in 

```Dockerfile
FROM k8spatterns/gomplate
COPY myconfig/ in/
```

So, you typically copy only your gomplate templates into the `/in` directory so that they are directly available in the image. The parameters filled into the templates are filled in during runtime by mounting a volume to `/params` from gomplate datasource files are picked up. These datasources are referenced from within the template directory. The processed files are then written to `/out`. This directory should be mounted as volume, too, so that these result files are accessible from the outside.


The entry point of this image is "/gomplate" and can be configured in various ways by providing custom arguments as `CMD` in a sub-image. All options available can be taken from [gomplate](https://github.com/hairyhenderson/gomplate), but for our use case the most important are:

* The `--input-dir` directory holds the templates. These are typically baked into the image like in this example.
* The `--datasource` is the directory containing the `gomplate` datasources. Each file in this directory is taken as an individual datasource which is used with the file's basename as key. E.g. a `config.yml` can be referenced from the template as `{{ (datasource "config").someKeyFromYamlFile }}`. This directory is typically mounted from the outside (e.g. from a Kubernetes `ConfigMap` backed volume).
* The `--output-dir` directory where to store the processed files. The generated files will have the same name as the input files. This directory is typically also pointing to a directory within a volume so that the processed files can be used from the application to configure.

For a full list of options see also `docker run -it k8spatterns/gomplate -h`.

### Recreate image

You need a Docker version with support _multi stage_ builds which are used here to compile gomplate fresh. You can use `build.sh` for recreating the image.
