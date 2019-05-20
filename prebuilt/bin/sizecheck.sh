#!/sbin/sh
# Copyright (c) 2019, The LineageOS Project
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of the LineageOS Project nor
#       the names of its contributors may be used to endorse or promote
#       products derived from this software without specific prior written
#       permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

size_valid=0
parted="/tmp/parted"

# Check for /system partition size
$parted /dev/block/mmcblk0p21 unit b p quit -> /tmp/sizecheck

# Cut /system partition size in bytes
egrep -o 'mmcblk0p21:.*B' /tmp/sizecheck >> /tmp/sizecheck2
sed 's/^.\{12\}//;s/.$//' /tmp/sizecheck2 >> /tmp/sizecheck3

# Compare /system partition size
if [ `cat /tmp/sizecheck3` -ge "1572863999" ]
then
  size_valid=1
else
  size_valid=0
fi

# Cleanup
rm /tmp/sizecheck
rm /tmp/sizecheck2
rm /tmp/sizecheck3

if [ $size_valid == 1 ]
then
	exit 1
else
	exit 0
fi
