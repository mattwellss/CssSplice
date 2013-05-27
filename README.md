CssSplice
=========

A tool to combine and split CSS files for refactoring

### Input files

**CssSplice** can load input stylesheets using the filesystem or from a website. In the config.yaml file, specify either *file* or *http* as the **type** and the proper location (**RELATIVE FOR FILESYSTEM**) of the stylesheet as the **uri**.

### Output files

Output is always dumped into the "output" folder, with the name of the new stylesheet as specified in the config.yaml file. The most important configuration option in CssSplice is here: **allowed_properties**. These are the CSS properties that are acceptable in the output file.
