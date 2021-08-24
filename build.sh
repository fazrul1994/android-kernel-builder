#!/usr/bin/env bash
echo "Downloading few Dependecies . . ."
sudo apt -y update 
sudo apt -y install git automake lzop bison gperf build-essential zip \
 curl zlib1g-dev g++-multilib libxml2-utils bzip2 libbz2-dev libbz2-1.0 \
 libghc-bzlib-dev squashfs-tools pngcrush schedtool dpkg-dev liblz4-tool make \
 optipng bc libstdc++6 libncurses5 wget python3 python3-pip python gcc clang  \
 libssl-dev rsync flex git-lfs libz3-dev libz3-4 axel tar gcc llvm lld g++-multilib clang default-jre libxml2

git config --global user.name "fazrul1994"
git config --global user.email "fazrulfadhilah@gmail.com"
git clone --depth=1 https://github.com/xyz-prjkt/xRageTC-clang xRage
git clone --depth=1 https://github.com/fazrul1994/ignominiOus_Poplar poplar

# Main
KERNEL_ROOTDIR=$(pwd)/poplar # IMPORTANT ! Fill with your kernel source root directory.
DEVICE_DEFCONFIG=ignominiOus-poplaR_defconfig # IMPORTANT ! Declare your kernel source defconfig file here.
CLANG_ROOTDIR=$(pwd)/xRage # IMPORTANT! Put your clang directory here.
export KBUILD_BUILD_USER=NoFace # Change with your own name or else.
export KBUILD_BUILD_HOST=NoName-circleCI # Change with your own hostname.
IMAGE=$(pwd)/poplar/out/arch/arm64/boot/Image.gz-dtb
DATE=$(date +"%F-%S")
START=$(date +"%s")

# Checking environtment
# Warning !! Dont Change anything there without known reason.
function check() {
echo ================================================
echo xKernelCompiler
echo version : rev1.5 - gaspoll
echo ================================================
echo BUILDER NAME = ${KBUILD_BUILD_USER}
echo BUILDER HOSTNAME = ${KBUILD_BUILD_HOST}
echo DEVICE_DEFCONFIG = ${DEVICE_DEFCONFIG}
echo CLANG_VERSION = $(${CLANG_ROOTDIR}/bin/clang --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g')
echo CLANG_ROOTDIR = ${CLANG_ROOTDIR}
echo KERNEL_ROOTDIR = ${KERNEL_ROOTDIR}
echo ================================================
}

# Compiler
function compile() {

   # Private CI
   curl -s -X POST "https://api.telegram.org/bot${TOKEN}/sendMessage" \
        -d chat_id="${CHAT_ID}" \
        -d "disable_web_page_preview=true" \
        -d "parse_mode=html" \
        -d text="<b>xKernelCompiler</b>%0ABUILDER NAME : <code>${KBUILD_BUILD_USER}</code>%0ABUILDER HOST : <code>${KBUILD_BUILD_HOST}</code>%0ADEVICE DEFCONFIG : <code>${DEVICE_DEFCONFIG}</code>%0ACLANG ROOTDIR : <code>${CLANG_ROOTDIR}</code>%0AKERNEL ROOTDIR : <code>${KERNEL_ROOTDIR}</code>"
        -d Build Started on : ${date}
   # xyzplaygrnd
   curl -s -X POST "https://api.telegram.org/bot${TOKEN}/sendMessage" \
        -d chat_id="-1001461733416" \
        -d "disable_web_page_preview=true" \
        -d "parse_mode=html" \
        -d text="<b>xKernelCompiler</b>%0ABUILDER NAME : <code>${KBUILD_BUILD_USER}</code>%0ABUILDER HOST : <code>${KBUILD_BUILD_HOST}</code>%0ADEVICE DEFCONFIG : <code>${DEVICE_DEFCONFIG}</code>%0ACLANG VERSION : <code>$(${CLANG_ROOTDIR}/bin/clang --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g')</code>%0ACLANG ROOTDIR : <code>${CLANG_ROOTDIR}</code>%0AKERNEL ROOTDIR : <code>${KERNEL_ROOTDIR}</code>"

  cd ${KERNEL_ROOTDIR}
  make -j$(nproc) O=out ARCH=arm64 ${DEVICE_DEFCONFIG}
  make -j36 ARCH=arm64 O=out \
  	CC=${CLANG_ROOTDIR}/bin/clang \
	AR=${CLANG_ROOTDIR}/bin/llvm-ar \
	NM=${CLANG_ROOTDIR}/bin/llvm-nm \
	OBJCOPY=${CLANG_ROOTDIR}/bin/llvm-objcopy \
	OBJDUMP=${CLANG_ROOTDIR}/bin/llvm-objdump \
	STRIP=${CLANG_ROOTDIR}/bin/llvm-strip \
	CROSS_COMPILE=${CLANG_ROOTDIR}/bin/aarch64-linux-gnu- \
	CROSS_COMPILE_ARM32=${CLANG_ROOTDIR}/bin/arm-linux-gnueabi-

   if ! [ -a "$IMAGE" ]; then
	finerr
	exit 1
   fi
        git clone --depth=1 https://github.com/fazrul1994/AnyKernel3 AnyKernel
	cp out/arch/arm64/boot/Image.gz-dtb AnyKernel
}


# sticker plox
function sticker() {
    curl -s -X POST "https://api.telegram.org/bot${TOKEN}/sendSticker" \
        -d sticker="CAACAgUAAxkBAAECyulhIzMSBNW-9ih_efmVdvpGMndPhgACHQIAAo_LJwW78W2ICybhxiAE" \
        -d chat_id="${CHAT_ID}"
}

function sticker() {
    curl -s -X POST "https://api.telegram.org/bot${TOKEN}/sendSticker" \
        -d sticker="CAACAgUAAxkBAAECyulhIzMSBNW-9ih_efmVdvpGMndPhgACHQIAAo_LJwW78W2ICybhxiAE" \
        -d chat_id="-1001461733416"
}

# Push kernel to channel
function push() {
    cd AnyKernel
    ZIP=$(echo *.zip)
    curl -F document=@$ZIP "https://api.telegram.org/bot${TOKEN}/sendDocument" \
        -F chat_id="${CHAT_ID}" \
        -F "disable_web_page_preview=true" \
        -F "parse_mode=html" \
        -F caption="Compile took $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) second(s). | For <b>Sony Xperia Xz1 (poplar)</b> | <b>$(${CLANG_ROOTDIR}/bin/clang --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g')</b>"

    curl -F document=@$ZIP "https://api.telegram.org/bot${TOKEN}/sendDocument" \
        -F chat_id="-1001461733416" \
        -F "disable_web_page_preview=true" \
        -F "parse_mode=html" \
        -F caption="Compile took $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) second(s). | For <b>Sony Xperia Xz1 (poplar)</b> | <b>$(${CLANG_ROOTDIR}/bin/clang --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g')</b>"

}
# Fin Error
function finerr() {
    curl -s -X POST "https://api.telegram.org/bot${TOKEN}/sendMessage" \
        -d chat_id="${CHAT_ID}" \
        -d "disable_web_page_preview=true" \
        -d "parse_mode=markdown" \
        -d text="Build throw an error(s)"

    curl -s -X POST "https://api.telegram.org/bot${TOKEN}/sendMessage" \
        -d chat_id="-1001461733416" \
        -d "disable_web_page_preview=true" \
        -d "parse_mode=markdown" \
        -d text="Build throw an error(s)"

    exit 1
}

# Zipping
function zipping() {
    cd AnyKernel || exit 1
    zip -r9 ignominiOus-poplar-${DATE}.zip *
    cd ..
}
check
compile
zipping
END=$(date +"%s")
DIFF=$(($END - $START))
push
