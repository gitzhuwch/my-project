sudo blkid
可能是我记岔了，没有proc或者sys节点中能获取uuid，gatway可以通过route或者/proc/xxx/net/route节点获取
2.4 UUID在文件系统中的使用
为解决上述问题，UUID被文件系统设计者采用，使其可以持久唯一标识一个硬盘分区。其实方式很简单，就是在文件系统的超级块中使用128位存放UUID。这个UUID是在使用文件系统格式化分区时计算生成的，例如Linux下的文件系统工具mkfs就在格式化分区的同时，生成UUID并把它记录到超级块的固定区域中。
下面是ext2文件系统超级块结构：
struct ext2_super_block
 { __u32   s_inodes_count;    /* 文件系统中索引节点总数 */
   __u32   s_blocks_count;    /*文件系统中总块数 */
   __u32   s_r_blocks_count;           /* 为超级用户保留的块数 */
   __u32   s_free_blocks_count;   /*文件系统中空闲块总数 */
   __u32   s_free_inodes_count;   /*文件系统中空闲索引节点总数*/
   __u32   s_first_data_block;              /* 文件系统中第一个数据块 */
   __u32   s_log_block_size;              /* 用于计算逻辑块大小 */
   __s32   s_log_frag_size;              /* 用于计算片大小 */
   __u32   s_blocks_per_group; /* 每组中块数 */
   __u32   s_frags_per_group;              /* 每组中片数 */
   __u32   s_inodes_per_group; /* 每组中索引节点数 */
   __u32   s_mtime;                      /*最后一次安装操作的时间 */
   __u32   s_wtime;             /*最后一次对该超级块进行写操作的时间 */
   __u16   s_mnt_count;       /* 安装计数 */
   __s16   s_max_mnt_count;                 /* 最大可安装计数 */
   __u16   s_magic;                    /* 用于确定文件系统版本的标志 */
   __u16   s_state;                      /* 文件系统的状态*/
   __u16   s_errors;                     /* 当检测到有错误时如何处理 */
   __u16   s_minor_rev_level;  /* 次版本号 */
   __u32   s_lastcheck;       /* 最后一次检测文件系统状态的时间 */
   __u32   s_checkinterval; /* 两次对文件系统状态进行检测的间隔时间 */
   __u32   s_rev_level;       /* 版本号 */
   __u16   s_def_resuid;      /* 保留块的默认用户标识号 */
   __u16   s_def_resgid;      /* 保留块的默认用户组标识号*/

 /*
  * These fields are for EXT2_DYNAMIC_REV superblocks only.
  *
  * Note: the difference between the compatible feature set and
  * the incompatible feature set is that if there is a bit set
  * in the incompatible feature set that the kernel doesn't
  * know about, it should refuse to mount the filesystem.
  *
  * e2fsck's requirements are more strict; if it doesn't know
  * about a feature in either the compatible or incompatible
  * feature set, it must abort and not try to meddle with
  * things it doesn't understand...
  */
__u32   s_first_ino;            /* 第一个非保留的索引节点 */
__u16   s_inode_size;           /* 索引节点的大小 */
  __u16   s_block_group_nr;       /* 该超级块的块组号 */
  __u32   s_feature_compat;       /* 兼容特点的位图*/
  __u32   s_feature_incompat;     /* 非兼容特点的位图 */
  __u32   s_feature_ro_compat;    /* 只读兼容特点的位图*/
  __u8    s_uuid[16];             /* 128位的文件系统标识号*/
  char    s_volume_name[16];      /* 卷名 */
  char    s_last_mounted[64];     /* 最后一个安装点的路径名 */
  __u32   s_algorithm_usage_bitmap; /* 用于压缩*/
   /*
   * Performance hints.  Directory preallocation should only
   * happen if the EXT2_COMPAT_PREALLOC flag is on.
   */
  __u8    s_prealloc_blocks;      /* 预分配的块数*/
  __u8    s_prealloc_dir_blocks;  /* 给目录预分配的块数 */
  __u16   s_padding1;
  __u32   s_reserved[204];        /* 用null填充块的末尾 */
 };
可以看到s_uuid[16]就是存放分区UUID的地方。
这样，无论硬盘分区的标识就永远不会重复，而且只要分区没有被重新格式化，那么标识此分区的UUID永远不变。
当然并不是所有的文件系统类型都支持UUID，例如微软的NTFS就不支持，而是采用了一个类似的其他机制。微软永远不走正路，真拿他没办法。
