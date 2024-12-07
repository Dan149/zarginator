# Zarginator
## Easy-to-use command line args management library for zig.

### How to add Zarginator package to your zig project:

First add Zarginator to your _build.zig.zon_ dependencies:

`zig fetch --save git+https://github.com/Dan149/zarginator/#HEAD`

Then add the dependency to your _build.zig_ file:

```
(...)

const zarginator_package = b.dependency("zarginator", .{
        .target = target,
        .optimize = optimize,
    });

const zarginator_module = zarginator_package.module("zarginator");
exe.root_module.addImport("zarginator", zarginator_module);
```

### How to use Zarginator:

Import: `const zarg = @import("zarginator");`

See [main.zig](src/main.zig) file
and Flag struct in [root.zig](src/root.zig#L3C1-L6C3) file.
