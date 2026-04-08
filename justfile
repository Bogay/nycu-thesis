root := justfile_directory()

# List available examples
list:
    @ls examples/

# Compile an example (default: demo)
compile example="demo":
    typst compile --root "{{root}}" "examples/{{example}}/main.typ"

# Watch an example for live preview (default: demo)
watch example="demo":
    typst watch --root "{{root}}" "examples/{{example}}/main.typ"

# Compile all examples
build-all:
    #!/usr/bin/env sh
    for dir in examples/*/; do
        example=$(basename "$dir")
        echo "Compiling $example..."
        typst compile --root "{{root}}" "examples/$example/main.typ"
    done

# Remove all compiled PDFs
clean:
    find examples -name "*.pdf" -delete
