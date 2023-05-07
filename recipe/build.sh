packageName=$PKG_NAME-$PKG_VERSION-$PKG_BUILDNUM
outdir=$PREFIX/share/$packageName

echo "### BUILD ENV INFO"
echo "PREFIX=$PREFIX"
echo "CONDA_PREFIX=$CONDA_PREFIX"
echo "LD_RUN_PATH=$LD_RUN_PATH"
echo "ARCH = $ARCH"
echo "OSX_ARCH = $OSX_ARCH"
echo "build_platform = $build_platform"
echo "target_platform = $target_platform"
echo "packageName=$packageName"
echo "outdir=$outdir"
echo "siriusDistName=$siriusDistName"
echo "### BUILD ENV INFO END"

echo "### Show Build dir"
ls -lah ./

echo "### Run gradle build on '$build_platform' for target platform: '$target_platform'"
./gradlew :sirius_dist:sirius_gui_dist:installSiriusDist \
  -P "build.sirius.location.lib=\$CONDA_PREFIX/share/$PKG_NAME-$PKG_VERSION-$PKG_BUILDNUM/app" \
  -P "build.sirius.starter.jdk.include=false" \
  -P "build.sirius.native.cbc.exclude=true" \
  -P "build.sirius.native.openjfx.exclude=false" \
  -P "build.sirius.platform=$target_platform"

echo "### Create package dirs"
mkdir -p "${outdir:?}"
mkdir -p "${PREFIX:?}/bin"

echo "### Copy jars"
cp -rp ./sirius_dist/sirius_gui_dist/build/install/$siriusDistName/* "${outdir:?}/"
rm -r "${outdir:?}/bin"

echo "### Show jar dir"
ls -lah "$outdir/app"

echo "### Copy starters"
cp -rp ./sirius_dist/sirius_gui_dist/build/install/$siriusDistName/bin/* "${PREFIX:?}/bin/"

echo "### Show bin dir"
ls -lah "$PREFIX/bin"

echo "### Show start script"
ls -lah "$PREFIX/bin/sirius"
cat "$PREFIX/bin/sirius"
