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
  uint64      st_dev;      /* ID of device containing file */
  uint64      st_ino;      /* Inode number */
  uint64     st_mode;     /* File type and mode */
  uint64    st_nlink;    /* Number of hard links */
  uint64      st_uid;      /* User ID of owner */
  uint64      st_gid;      /* Group ID of owner */
  uint64      st_rdev;     /* Device ID (if special file) */
  uint64      st_size;     /* Total size, in bytes */
  uint64  st_blksize;  /* Block size for filesystem I/O */
  uint64   st_blocks;   /* Number of 512 B blocks allocated */
};
// struct stat {
//   int dev;     // File system's disk device
//   uint ino;    // Inode number
//   short type;  // Type of file
//   short nlink; // Number of links to file
//   uint64 size; // Size of file in bytes
// };

#endif