{
  description = "Project starters for multi-executable student applications";

  outputs = { self }: {
    templates = {
      go = {
        path = ./templates/go;
        description = "Go multi-executable application";
      };

      cpp = {
        path = ./templates/cpp;
        description = "C++ multi-executable application";
      };

      rust = {
        path = ./templates/rust;
        description = "Rust multi-executable application";
      };

      python = {
        path = ./templates/python;
        description = "Python multi-executable application";
      };

      javascript = {
        path = ./templates/javascript;
        description = "JavaScript multi-executable application";
      };

      haskell = {
        path = ./templates/haskell;
        description = "Haskell multi-executable application";
      };

      ocaml = {
        path = ./templates/ocaml;
        description = "OCaml multi-executable application";
      };

      c = {
        path = ./templates/c;
        description = "C multi-executable application";
      };

      java = {
        path = ./templates/java;
        description = "Java multi-executable application";
      };

      scala = {
        path = ./templates/scala;
        description = "Scala multi-executable application";
      };

      kotlin = {
        path = ./templates/kotlin;
        description = "Kotlin multi-executable application";
      };

      typescript = {
        path = ./templates/typescript;
        description = "TypeScript multi-executable application";
      };

      default = self.templates.go;
    };
  };
}
