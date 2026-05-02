#ifndef __STAT_H
#define __STAT_H

#define T_DIR     1   // Directory
#define T_FILE    2   // File
#define T_DEVICE  3   // Device

#define STAT_MAX_NAME 32

struct stat {
  char name[STAT_MAX_NAME + 1];
  int dev;     // File system's disk device
  short type;  // Type of file
  uint64 size; // Size of file in bytes
};

struct stat2 {
  uint64      st_dev;         //  0
  uint64      st_ino;         //  8
  uint32      st_mode;        // 16
  uint32      st_nlink;       // 20
  uint32      st_uid;         // 24
  uint32      st_gid;         // 28
  uint64      st_rdev;        // 32
  uint64      __pad;          // 40
  uint64      st_size;        // 48
  uint64      st_blksize;     // 56
  uint64      st_blocks;      // 64
  uint64      st_atime_sec;   // 72
  uint64      st_atime_nsec;  // 80
  uint64      st_mtime_sec;   // 88
  uint64      st_mtime_nsec;  // 96
  uint64      st_ctime_sec;   // 104
  uint64      st_ctime_nsec;  // 112
};
// struct stat {
//   int dev;     // File system's disk device
//   uint ino;    // Inode number
//   short type;  // Type of file
//   short nlink; // Number of links to file
//   uint64 size; // Size of file in bytes
// };

#endif