{ conf-target
, name-target
, pkgs
}:
let
	musl-src = builtins.fetchGit {
		url = "https://github.com/kraj/musl.git";
		rev = "0784374d561435f7c787a555aeab8ede699ed298";
		shallow = true;
	};
	aarch64-compiler-rt = builtins.fetchTarball {
		url = "http://mirror.archlinuxarm.org/aarch64/extra/compiler-rt-20.1.8-1-aarch64.pkg.tar.xz";
		sha256 = "14zn7ksalcmc180b79wc6chkyv2979y3raac1rq97fxqdvay29gg";
	};
in pkgs.stdenvNoCC.mkDerivation {
	name = "libc-${name-target}";

	src = musl-src;

	nativeBuildInputs = [ pkgs.clang pkgs.lld pkgs.coreutils ];

	configurePhase =
	(if name-target == "arm64" then ''
		cp -r ${aarch64-compiler-rt}/. ./compiler-rt
	''else "") +
	''
		CC="clang --target=${conf-target}-linux-musl" \
			CFLAGS="-O2" \
			LDFLAGS="-fuse-ld=lld ${if name-target == "arm64" then "./compiler-rt/usr/lib/clang/20/lib/linux/libclang_rt.builtins-aarch64.a" else ""}" \
			./configure --target=${conf-target}
	'';

	buildPhase = ''
		make -j lib/libc.so
	'';

	installPhase = ''
		mkdir -p "$out/lib"
		cp lib/libc.so "$out/lib/libc.so"
	'';
}
