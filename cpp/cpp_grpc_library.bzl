load("//cpp:cpp_grpc_compile.bzl", "cpp_grpc_compile")

def cpp_grpc_library(**kwargs):
    # Compile protos
    name_pb = kwargs.get("name") + "_pb"
    cpp_grpc_compile(
        name = name_pb,
        **{k: v for (k, v) in kwargs.items() if k in ("protos" if "protos" in kwargs else "deps", "verbose")}  # Forward args
    )

    # Create cpp library
    native.cc_library(
        name = kwargs.get("name"),
        srcs = [name_pb],
        deps = GRPC_DEPS + (kwargs.get("deps", []) if "protos" in kwargs else []),
        includes = [name_pb],
        visibility = kwargs.get("visibility"),
        tags = kwargs.get("tags"),
    )

GRPC_DEPS = [
    "@com_google_protobuf//:protobuf",
    "@com_github_grpc_grpc//:grpc++",
    "@com_github_grpc_grpc//:grpc++_reflection",
]
