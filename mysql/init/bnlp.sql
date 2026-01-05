SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for l_load_document
-- ----------------------------
DROP TABLE IF EXISTS `l_load_document`;
CREATE TABLE `l_load_document`  (
  `id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `import_log_id` bigint(11) NULL DEFAULT NULL,
  `project_id` bigint(20) NOT NULL,
  `batch_id` bigint(20) NOT NULL,
  `article_id` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `document_id` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `status` tinyint(2) NULL DEFAULT NULL,
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `no`(`no`) USING BTREE,
  INDEX `batch_id`(`batch_id`) USING BTREE,
  INDEX `project_id`(`project_id`) USING BTREE,
  INDEX `article_id`(`article_id`) USING BTREE,
  INDEX `status`(`status`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of l_load_document
-- ----------------------------

-- ----------------------------
-- Table structure for l_operation
-- ----------------------------
DROP TABLE IF EXISTS `l_operation`;
CREATE TABLE `l_operation`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `note_id` bigint(20) NOT NULL,
  `task_id` bigint(20) NULL DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `operation` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作模块',
  `type` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作类型',
  `msg` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '信息',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `deleted` int(11) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of l_operation
-- ----------------------------

-- ----------------------------
-- Table structure for l_statistics_project
-- ----------------------------
DROP TABLE IF EXISTS `l_statistics_project`;
CREATE TABLE `l_statistics_project`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `project_id` bigint(20) NOT NULL,
  `unmarked` int(11) NOT NULL DEFAULT 0,
  `marked` int(11) NOT NULL DEFAULT 0,
  `reviewed` int(11) NOT NULL DEFAULT 0,
  `create_time` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `project_id`(`project_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of l_statistics_project
-- ----------------------------

-- ----------------------------
-- Table structure for sys_captcha
-- ----------------------------
DROP TABLE IF EXISTS `sys_captcha`;
CREATE TABLE `sys_captcha`  (
  `uuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'uuid',
  `code` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '验证码',
  `expire_time` datetime NULL DEFAULT NULL COMMENT '过期时间',
  PRIMARY KEY (`uuid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统验证码' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_captcha
-- ----------------------------

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `param_key` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'key',
  `param_value` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'value',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态   0：隐藏   1：显示',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `param_key`(`param_key`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统配置信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, 'resetPassword', '123456@Bnlp', 1, '');

-- ----------------------------
-- Table structure for sys_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_log`;
CREATE TABLE `sys_log`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户名',
  `operation` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户操作',
  `method` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '请求方法',
  `params` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `time` bigint(20) NOT NULL COMMENT '执行时长(毫秒)',
  `ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'IP地址',
  `create_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `parent_id` bigint(20) NULL DEFAULT NULL COMMENT '父菜单ID，一级菜单为0',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '菜单名称',
  `url` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '菜单URL',
  `perms` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '授权(多个用逗号分隔，如：user:list,user:create)',
  `type` int(11) NULL DEFAULT NULL COMMENT '类型   0：目录   1：菜单   2：按钮',
  `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '菜单图标',
  `order_num` int(11) NULL DEFAULT NULL COMMENT '排序',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 86 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '菜单管理' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, 0, '系统管理', NULL, NULL, 0, 'system', 10);
INSERT INTO `sys_menu` VALUES (2, 1, '用户列表', 'sys/user', NULL, 1, 'admin', 1);
INSERT INTO `sys_menu` VALUES (3, 1, '角色管理', 'sys/role', NULL, 1, 'role', 2);
INSERT INTO `sys_menu` VALUES (4, 1, '菜单管理', 'sys/menu', NULL, 1, 'menu', 3);
INSERT INTO `sys_menu` VALUES (5, 1, 'SQL监控', 'http://localhost:8080/nlp/druid/sql.html', NULL, 1, 'sql', 4);
INSERT INTO `sys_menu` VALUES (15, 2, '查看', NULL, 'sys:user:list,sys:user:info', 2, NULL, 0);
INSERT INTO `sys_menu` VALUES (16, 2, '新增', NULL, 'sys:user:save,sys:role:select', 2, NULL, 0);
INSERT INTO `sys_menu` VALUES (17, 2, '修改', NULL, 'sys:user:update,sys:role:select', 2, NULL, 0);
INSERT INTO `sys_menu` VALUES (18, 2, '删除', NULL, 'sys:user:delete', 2, NULL, 0);
INSERT INTO `sys_menu` VALUES (19, 3, '查看', NULL, 'sys:role:list,sys:role:info', 2, NULL, 0);
INSERT INTO `sys_menu` VALUES (20, 3, '新增', NULL, 'sys:role:save,sys:menu:list', 2, NULL, 0);
INSERT INTO `sys_menu` VALUES (21, 3, '修改', NULL, 'sys:role:update,sys:menu:list', 2, NULL, 0);
INSERT INTO `sys_menu` VALUES (22, 3, '删除', NULL, 'sys:role:delete', 2, NULL, 0);
INSERT INTO `sys_menu` VALUES (23, 4, '查看', NULL, 'sys:menu:list,sys:menu:info', 2, NULL, 0);
INSERT INTO `sys_menu` VALUES (24, 4, '新增', NULL, 'sys:menu:save,sys:menu:select', 2, NULL, 0);
INSERT INTO `sys_menu` VALUES (25, 4, '修改', NULL, 'sys:menu:update,sys:menu:select', 2, NULL, 0);
INSERT INTO `sys_menu` VALUES (26, 4, '删除', NULL, 'sys:menu:delete', 2, NULL, 0);
INSERT INTO `sys_menu` VALUES (27, 1, '参数管理', 'sys/config', 'sys:config:list,sys:config:info,sys:config:save,sys:config:update,sys:config:delete', 1, 'config', 6);
INSERT INTO `sys_menu` VALUES (29, 1, '系统日志', 'sys/log', 'sys:log:list', 1, 'log', 7);
INSERT INTO `sys_menu` VALUES (30, 1, '文件上传', 'oss/oss', 'sys:oss:all', 1, 'oss', 6);
INSERT INTO `sys_menu` VALUES (31, 0, '文献标注', '', '', 0, 'log', 1);
INSERT INTO `sys_menu` VALUES (44, 0, '项目管理', 'project/list', 'project:manage', 1, 'project', 1);
INSERT INTO `sys_menu` VALUES (59, 0, '标注记录', 'annotation/anno-history', '', 1, 'bianji', 2);
INSERT INTO `sys_menu` VALUES (60, 0, '标注说明', 'instruction/project', 'annotator', 1, 'pdf', 5);
INSERT INTO `sys_menu` VALUES (64, 44, '所有可编辑按钮权限(项目管理员)', '', 'project:editable', 2, '', 0);
INSERT INTO `sys_menu` VALUES (66, 0, '任务列表', 'annotask/list', 'annotask:list', 1, 'list', 6);
INSERT INTO `sys_menu` VALUES (67, 0, '标签管理', '', '', 0, 'labels', 2);
INSERT INTO `sys_menu` VALUES (68, 67, '实体标签', 'labels/entity', 'label:delete,label:update,label:save,label:info,label:list', 1, 'entity-label', 0);
INSERT INTO `sys_menu` VALUES (69, 67, '关系标签', 'labels/relation', 'label:list,label:info,label:save,label:update,label:delete', 1, 'relation', 0);
INSERT INTO `sys_menu` VALUES (70, 67, '模板管理', 'labels/pattern', '', 1, 'moban', 0);
INSERT INTO `sys_menu` VALUES (71, 66, '批量标注', '', 'task:batch:annotation', 2, '', 0);
INSERT INTO `sys_menu` VALUES (72, 66, '批量审核', '', 'task:batch:auditor', 2, '', 0);
INSERT INTO `sys_menu` VALUES (73, 66, '标注', NULL, 'task:annotation', 2, NULL, 0);
INSERT INTO `sys_menu` VALUES (74, 66, '审核', '', 'task:auditor', 2, '', 0);
INSERT INTO `sys_menu` VALUES (75, 66, '标注员列表', '', 'task:auditor:annotator:list', 2, '', 0);
INSERT INTO `sys_menu` VALUES (77, 66, '提交标注', '', 'task:detail:annSubmit', 2, '', 0);
INSERT INTO `sys_menu` VALUES (78, 66, '废弃', '', 'task:detail:invalid', 2, '', 0);
INSERT INTO `sys_menu` VALUES (79, 66, '打回', '', 'task:detail:repulse', 2, '', 0);
INSERT INTO `sys_menu` VALUES (80, 66, '重新提交', '', 'task:detail:resubmit', 2, '', 0);
INSERT INTO `sys_menu` VALUES (81, 66, '导入到原文', '', 'task:detail:import', 2, '', 0);
INSERT INTO `sys_menu` VALUES (82, 66, '提交审核', NULL, 'task:detail:auditorSubmit', 2, NULL, 0);
INSERT INTO `sys_menu` VALUES (83, 66, '重新标注', '', 'task:batch:reAnnotator', 2, '', 0);
INSERT INTO `sys_menu` VALUES (84, 66, '重新审核', '', 'task:batch:reAuditor', 2, '', 0);
INSERT INTO `sys_menu` VALUES (85, 0, 'AI预标注', 'tool/ai-pre-anno', '', 1, 'robot', 3);

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `role_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '角色名称',
  `remark` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_user_id` bigint(20) NULL DEFAULT NULL COMMENT '创建者ID',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', '超级管理员，可以管理系统', 1, '2020-11-15 19:30:43');
INSERT INTO `sys_role` VALUES (2, '标注员', '标注员', 1, '2020-12-01 09:10:53');
INSERT INTO `sys_role` VALUES (3, '审核员', '审核员', 1, '2020-12-01 09:11:20');
INSERT INTO `sys_role` VALUES (8, '项目管理员', '项目管理员', 1, '2020-12-06 14:39:51');
INSERT INTO `sys_role` VALUES (9, '项目观察员', '项目观察员', 1, '2021-07-28 11:39:36');
INSERT INTO `sys_role` VALUES (10, '系统管理员', '可以管理用户和参数', 1, '2023-06-12 16:54:41');

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `role_id` bigint(20) NULL DEFAULT NULL COMMENT '角色ID',
  `menu_id` bigint(20) NULL DEFAULT NULL COMMENT '菜单ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1519 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色与菜单对应关系' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (1215, 9, -666666);
INSERT INTO `sys_role_menu` VALUES (1216, 9, 44);
INSERT INTO `sys_role_menu` VALUES (1358, 1, 2);
INSERT INTO `sys_role_menu` VALUES (1359, 1, 15);
INSERT INTO `sys_role_menu` VALUES (1360, 1, 16);
INSERT INTO `sys_role_menu` VALUES (1361, 1, 17);
INSERT INTO `sys_role_menu` VALUES (1362, 1, 18);
INSERT INTO `sys_role_menu` VALUES (1363, 1, 3);
INSERT INTO `sys_role_menu` VALUES (1364, 1, 19);
INSERT INTO `sys_role_menu` VALUES (1365, 1, 20);
INSERT INTO `sys_role_menu` VALUES (1366, 1, 21);
INSERT INTO `sys_role_menu` VALUES (1367, 1, 22);
INSERT INTO `sys_role_menu` VALUES (1368, 1, 4);
INSERT INTO `sys_role_menu` VALUES (1369, 1, 23);
INSERT INTO `sys_role_menu` VALUES (1370, 1, 24);
INSERT INTO `sys_role_menu` VALUES (1371, 1, 25);
INSERT INTO `sys_role_menu` VALUES (1372, 1, 26);
INSERT INTO `sys_role_menu` VALUES (1373, 1, 27);
INSERT INTO `sys_role_menu` VALUES (1374, 1, 29);
INSERT INTO `sys_role_menu` VALUES (1375, 1, 67);
INSERT INTO `sys_role_menu` VALUES (1376, 1, 68);
INSERT INTO `sys_role_menu` VALUES (1377, 1, 69);
INSERT INTO `sys_role_menu` VALUES (1378, 1, 70);
INSERT INTO `sys_role_menu` VALUES (1379, 1, -666666);
INSERT INTO `sys_role_menu` VALUES (1380, 1, 1);
INSERT INTO `sys_role_menu` VALUES (1472, 2, 71);
INSERT INTO `sys_role_menu` VALUES (1473, 2, 73);
INSERT INTO `sys_role_menu` VALUES (1474, 2, 77);
INSERT INTO `sys_role_menu` VALUES (1475, 2, 78);
INSERT INTO `sys_role_menu` VALUES (1476, 2, 80);
INSERT INTO `sys_role_menu` VALUES (1477, 2, 81);
INSERT INTO `sys_role_menu` VALUES (1478, 2, 83);
INSERT INTO `sys_role_menu` VALUES (1479, 2, -666666);
INSERT INTO `sys_role_menu` VALUES (1480, 2, 66);
INSERT INTO `sys_role_menu` VALUES (1481, 3, 72);
INSERT INTO `sys_role_menu` VALUES (1482, 3, 74);
INSERT INTO `sys_role_menu` VALUES (1483, 3, 75);
INSERT INTO `sys_role_menu` VALUES (1484, 3, 79);
INSERT INTO `sys_role_menu` VALUES (1485, 3, 81);
INSERT INTO `sys_role_menu` VALUES (1486, 3, 82);
INSERT INTO `sys_role_menu` VALUES (1487, 3, 84);
INSERT INTO `sys_role_menu` VALUES (1488, 3, -666666);
INSERT INTO `sys_role_menu` VALUES (1489, 3, 66);
INSERT INTO `sys_role_menu` VALUES (1502, 10, 2);
INSERT INTO `sys_role_menu` VALUES (1503, 10, 15);
INSERT INTO `sys_role_menu` VALUES (1504, 10, 16);
INSERT INTO `sys_role_menu` VALUES (1505, 10, 17);
INSERT INTO `sys_role_menu` VALUES (1506, 10, 18);
INSERT INTO `sys_role_menu` VALUES (1507, 10, 27);
INSERT INTO `sys_role_menu` VALUES (1508, 10, 29);
INSERT INTO `sys_role_menu` VALUES (1509, 10, 67);
INSERT INTO `sys_role_menu` VALUES (1510, 10, 68);
INSERT INTO `sys_role_menu` VALUES (1511, 10, 69);
INSERT INTO `sys_role_menu` VALUES (1512, 10, 70);
INSERT INTO `sys_role_menu` VALUES (1513, 10, -666666);
INSERT INTO `sys_role_menu` VALUES (1514, 10, 1);
INSERT INTO `sys_role_menu` VALUES (1515, 8, 44);
INSERT INTO `sys_role_menu` VALUES (1516, 8, 64);
INSERT INTO `sys_role_menu` VALUES (1517, 8, 85);
INSERT INTO `sys_role_menu` VALUES (1518, 8, -666666);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户名',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '密码',
  `salt` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '盐',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `mobile` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '手机号',
  `status` tinyint(4) NULL DEFAULT NULL COMMENT '状态  0：禁用   1：正常',
  `create_user_id` bigint(20) NULL DEFAULT NULL COMMENT '创建者ID',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`user_id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 124 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统用户' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'admin', '0614e64642c91ff762d5925a82991185c4ec9f6ecf9c345add10d98df293233d', '3cSLOxlzss1pheEaA8Lc', 'root@xxx.io', '13600000000', 1, 1, '2016-11-11 11:11:11');
INSERT INTO `sys_user` VALUES (122, 'test1', '9d73c699259d07c029b24bc0b9f7cfb1d8eaff2007aa457992151ff765b719cc', 'orC7siocrLTvmF0UVgfe', '', '', 1, 1, '2026-01-04 20:41:44');
INSERT INTO `sys_user` VALUES (123, 'test2', '7f005daf8dc3a07aa131b767c7247bf150604fb990ee09049d6d5c121fee1228', 'hUGoi7l5C5jlfetL8nb9', '', '', 1, 1, '2026-01-04 20:42:15');

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NULL DEFAULT NULL COMMENT '用户ID',
  `role_id` bigint(20) NULL DEFAULT NULL COMMENT '角色ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 408 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户与角色对应关系' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (3, 1, 1);
INSERT INTO `sys_user_role` VALUES (400, 122, 2);
INSERT INTO `sys_user_role` VALUES (401, 122, 3);
INSERT INTO `sys_user_role` VALUES (402, 122, 8);
INSERT INTO `sys_user_role` VALUES (403, 122, 9);
INSERT INTO `sys_user_role` VALUES (404, 123, 2);
INSERT INTO `sys_user_role` VALUES (405, 123, 3);
INSERT INTO `sys_user_role` VALUES (406, 123, 8);
INSERT INTO `sys_user_role` VALUES (407, 123, 9);

-- ----------------------------
-- Table structure for sys_user_token
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_token`;
CREATE TABLE `sys_user_token`  (
  `user_id` bigint(20) NOT NULL,
  `token` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'token',
  `expire_time` datetime NULL DEFAULT NULL COMMENT '过期时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`user_id`) USING BTREE,
  UNIQUE INDEX `token`(`token`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统用户Token' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_token
-- ----------------------------

-- ----------------------------
-- Table structure for t_ai_pre_anno_task
-- ----------------------------
DROP TABLE IF EXISTS `t_ai_pre_anno_task`;
CREATE TABLE `t_ai_pre_anno_task`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `project_id` bigint(20) NULL DEFAULT NULL COMMENT 'ID',
  `source_batch_id` bigint(20) NULL DEFAULT NULL COMMENT 'ID',
  `source_article_ids_str` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT 'ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `status` tinyint(4) NULL DEFAULT 0 COMMENT ': 0-, 1-, 2-',
  `prompt` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `ai_model` varchar(240) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `endpoint` varchar(240) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `api_key` varchar(240) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `chunk_size` int(8) NULL DEFAULT NULL,
  `batch_id` bigint(20) NULL DEFAULT NULL COMMENT 'ID',
  `article_ids_str` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT 'ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `end_time` datetime NULL DEFAULT NULL,
  `prompt_tokens` bigint(20) NULL DEFAULT NULL,
  `completion_tokens` bigint(20) NULL DEFAULT NULL,
  `total_tokens` bigint(20) NULL DEFAULT NULL,
  `creator` bigint(20) NULL DEFAULT NULL COMMENT 'ID',
  `deleted` tinyint(4) NULL DEFAULT 0 COMMENT ': 0-, 1-',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_project_id`(`project_id`) USING BTREE,
  INDEX `idx_batch_id`(`batch_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_ai_pre_anno_task
-- ----------------------------

-- ----------------------------
-- Table structure for t_attachment
-- ----------------------------
DROP TABLE IF EXISTS `t_attachment`;
CREATE TABLE `t_attachment`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `original_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  `deleted` tinyint(2) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_attachment
-- ----------------------------

-- ----------------------------
-- Table structure for t_attribute_label
-- ----------------------------
DROP TABLE IF EXISTS `t_attribute_label`;
CREATE TABLE `t_attribute_label`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `entity_label_id` bigint(11) NULL DEFAULT NULL COMMENT '实体标签ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '属性名',
  `field` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标签代码',
  `order_number` int(5) NULL DEFAULT NULL COMMENT '排序',
  `status` int(11) NOT NULL DEFAULT 0 COMMENT '停启状态(1是正常，0是禁用)',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `deleted` int(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除 1代表删除 0代表未删除',
  `pkg_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `pkg_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `pkg_version` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `pkg_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `label_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `label_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `label_version` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `label_ser_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `status`(`status`) USING BTREE,
  INDEX `deleted`(`deleted`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_attribute_label
-- ----------------------------

-- ----------------------------
-- Table structure for t_batch
-- ----------------------------
DROP TABLE IF EXISTS `t_batch`;
CREATE TABLE `t_batch`  (
  `batch_id` int(20) NOT NULL AUTO_INCREMENT,
  `project_id` int(20) NOT NULL,
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `material_source` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `search_criteria` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `create_time` datetime NOT NULL,
  `update_time` datetime NOT NULL,
  `total_article` int(20) NOT NULL DEFAULT 0,
  `status` int(2) NOT NULL DEFAULT 1,
  `deleted` tinyint(2) NOT NULL DEFAULT 0,
  `import_status` int(2) NULL DEFAULT NULL,
  `free` tinyint(1) NULL DEFAULT 0,
  `mode` tinyint(1) NULL DEFAULT 0,
  PRIMARY KEY (`batch_id`) USING BTREE,
  INDEX `project_id`(`project_id`) USING BTREE,
  INDEX `name`(`name`) USING BTREE,
  INDEX `status`(`status`) USING BTREE,
  INDEX `deleted`(`deleted`) USING BTREE,
  INDEX `import_status`(`import_status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_batch
-- ----------------------------

-- ----------------------------
-- Table structure for t_entity_label
-- ----------------------------
DROP TABLE IF EXISTS `t_entity_label`;
CREATE TABLE `t_entity_label`  (
  `id` bigint(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `project_id` bigint(11) NOT NULL DEFAULT 0 COMMENT '0是公共标签，其他是私有标签',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '标签名字',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `color` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `order_num` int(11) NOT NULL DEFAULT 1,
  `status` int(11) NULL DEFAULT 1 COMMENT '停启状态(1是正常，0是禁用)',
  `disambiguate` tinyint(1) NULL DEFAULT 0 COMMENT '消歧',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `deleted` int(11) NOT NULL DEFAULT 0 COMMENT '逻辑删除 1代表删除 0代表未删除',
  `pkg_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `pkg_code` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `pkg_version` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `pkg_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `label_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `label_code` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `label_version` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `label_ser_code` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `project_id`(`project_id`) USING BTREE,
  INDEX `name`(`name`) USING BTREE,
  INDEX `status`(`status`) USING BTREE,
  INDEX `deleted`(`deleted`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_entity_label
-- ----------------------------

-- ----------------------------
-- Table structure for t_export_log
-- ----------------------------
DROP TABLE IF EXISTS `t_export_log`;
CREATE TABLE `t_export_log`  (
  `id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `project_id` bigint(20) NULL DEFAULT NULL,
  `batch_id` bigint(20) NULL DEFAULT NULL,
  `module` int(10) NULL DEFAULT NULL,
  `type` int(10) NULL DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  `finish_time` datetime NULL DEFAULT NULL,
  `status` int(10) NULL DEFAULT NULL,
  `output_file_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `user_id` bigint(20) NULL DEFAULT NULL,
  `deleted` tinyint(2) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_export_log
-- ----------------------------

-- ----------------------------
-- Table structure for t_import_log
-- ----------------------------
DROP TABLE IF EXISTS `t_import_log`;
CREATE TABLE `t_import_log`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `project_id` bigint(20) NULL DEFAULT NULL,
  `batch_id` bigint(20) NULL DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `type` tinyint(2) NULL DEFAULT NULL,
  `status` tinyint(2) NULL DEFAULT NULL,
  `enabled` tinyint(2) NOT NULL DEFAULT 1,
  `create_time` datetime NULL DEFAULT NULL,
  `finish_time` datetime NULL DEFAULT NULL,
  `import_file_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `log_file_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `user_id` bigint(20) NULL DEFAULT NULL,
  `deleted` tinyint(1) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_import_log
-- ----------------------------

-- ----------------------------
-- Table structure for t_label_rules
-- ----------------------------
DROP TABLE IF EXISTS `t_label_rules`;
CREATE TABLE `t_label_rules`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `project_id` bigint(20) NOT NULL COMMENT 'ID',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT 'Markdown',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_user_id` bigint(20) NULL DEFAULT NULL COMMENT 'ID',
  `update_user_id` bigint(20) NULL DEFAULT NULL COMMENT 'ID',
  `deleted` tinyint(1) NULL DEFAULT 0 COMMENT '(10)',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_project_id`(`project_id`, `deleted`) USING BTREE COMMENT 'ID',
  INDEX `idx_project_id`(`project_id`) USING BTREE COMMENT 'ID'
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_label_rules
-- ----------------------------

-- ----------------------------
-- Table structure for t_note
-- ----------------------------
DROP TABLE IF EXISTS `t_note`;
CREATE TABLE `t_note`  (
  `note_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `project_id` bigint(20) NOT NULL COMMENT '项目ID',
  `batch_id` bigint(20) NOT NULL COMMENT '批次ID',
  `document_id` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'ID',
  `words_count` int(11) NOT NULL DEFAULT 0,
  `article_id` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'ID',
  `article_name` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '文章名',
  `step` int(11) NOT NULL COMMENT '0未标注，1标注中，2已标注，3审核中，4已审核',
  `pull_count` int(2) NULL DEFAULT NULL COMMENT '被拉取次数',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '修改时间',
  `invalid` tinyint(2) NULL DEFAULT 0 COMMENT '是否废弃',
  `deleted` int(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`note_id`) USING BTREE,
  INDEX `batch_id`(`batch_id`) USING BTREE,
  INDEX `article_id`(`article_id`) USING BTREE,
  INDEX `status`(`step`) USING BTREE,
  INDEX `update_time`(`update_time`) USING BTREE,
  INDEX `project_id`(`project_id`) USING BTREE,
  INDEX `deleted`(`deleted`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_note
-- ----------------------------

-- ----------------------------
-- Table structure for t_note_task
-- ----------------------------
DROP TABLE IF EXISTS `t_note_task`;
CREATE TABLE `t_note_task`  (
  `task_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `project_id` bigint(11) NOT NULL,
  `batch_id` bigint(11) NOT NULL,
  `note_id` bigint(20) NOT NULL,
  `step` int(11) NOT NULL COMMENT '0未标注  1标注中  2已标注  3审核中  4已审核  5打回  6已修正',
  `invalid` tinyint(2) NOT NULL DEFAULT 0 COMMENT '是否废弃',
  `annotator` bigint(20) NOT NULL COMMENT '标注员ID',
  `anno_start_time` datetime NULL DEFAULT NULL COMMENT '标注开始时间',
  `anno_end_time` datetime NULL DEFAULT NULL COMMENT '标注结束时间',
  `auditor` bigint(20) NULL DEFAULT NULL COMMENT '审核员ID',
  `audit_start_time` datetime NULL DEFAULT NULL COMMENT '审核开始时间',
  `audit_end_time` datetime NULL DEFAULT NULL COMMENT '审核结束时间',
  `repulse_msg` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '打回的批注信息',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '修改时间',
  `deleted` int(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  `master` int(1) NOT NULL DEFAULT 0 COMMENT '是否为基础蓝本任务,0非蓝本，1蓝本，用于多人标注审核',
  `pre_relation_imported` int(1) NOT NULL DEFAULT 0 COMMENT '关系预标注是否已经导入完毕，0未导入，1已导入',
  `md5` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '标注员标注完毕全文的MD5',
  `correct_rate` float(5, 2) NULL DEFAULT NULL COMMENT '标注员标注结果准确率',
  `correct_entity` bigint(20) NULL DEFAULT NULL,
  `correct_attr` bigint(20) NULL DEFAULT NULL,
  `correct_relation` bigint(20) NULL DEFAULT NULL,
  `need_total` bigint(20) NULL DEFAULT 0,
  `correct_total` bigint(20) NULL DEFAULT 0,
  `error_total` bigint(20) NULL DEFAULT 0,
  `miss_total` bigint(20) NULL DEFAULT 0,
  `queries` int(10) NOT NULL DEFAULT 0,
  PRIMARY KEY (`task_id`) USING BTREE,
  INDEX `step`(`step`) USING BTREE,
  INDEX `update_time`(`update_time`) USING BTREE,
  INDEX `deleted`(`deleted`) USING BTREE,
  INDEX `project_id`(`project_id`) USING BTREE,
  INDEX `batch_id`(`batch_id`) USING BTREE,
  INDEX `auditor`(`auditor`) USING BTREE,
  INDEX `note_id`(`note_id`) USING BTREE,
  INDEX `annotator`(`annotator`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_note_task
-- ----------------------------

-- ----------------------------
-- Table structure for t_project
-- ----------------------------
DROP TABLE IF EXISTS `t_project`;
CREATE TABLE `t_project`  (
  `project_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `creator_id` bigint(20) NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `create_time` datetime NOT NULL,
  `update_time` datetime NOT NULL,
  `status` tinyint(2) NOT NULL DEFAULT 1,
  `label_source` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'custom',
  `markdown_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `pre_sources` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `deleted` tinyint(2) NOT NULL DEFAULT 0,
  `mark_rounds` int(1) NOT NULL COMMENT '标注轮数',
  `auto_review` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`project_id`) USING BTREE,
  UNIQUE INDEX `code`(`code`) USING BTREE,
  INDEX `name`(`name`) USING BTREE,
  INDEX `status`(`status`) USING BTREE,
  INDEX `creator_id`(`creator_id`) USING BTREE,
  INDEX `deleted`(`deleted`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_project
-- ----------------------------

-- ----------------------------
-- Table structure for t_project_user
-- ----------------------------
DROP TABLE IF EXISTS `t_project_user`;
CREATE TABLE `t_project_user`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `project_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `role_id` int(2) NOT NULL,
  `deleted` tinyint(2) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `project_id`(`project_id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  INDEX `role_id`(`role_id`) USING BTREE,
  INDEX `deleted`(`deleted`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_project_user
-- ----------------------------

-- ----------------------------
-- Table structure for t_relation_import
-- ----------------------------
DROP TABLE IF EXISTS `t_relation_import`;
CREATE TABLE `t_relation_import`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NULL DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  `finish_time` datetime NULL DEFAULT NULL,
  `log_file_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `deleted` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_relation_import
-- ----------------------------

-- ----------------------------
-- Table structure for t_relation_label
-- ----------------------------
DROP TABLE IF EXISTS `t_relation_label`;
CREATE TABLE `t_relation_label`  (
  `id` bigint(11) NOT NULL AUTO_INCREMENT,
  `special` int(11) NULL DEFAULT NULL COMMENT '0是普通标签，一是特殊标签',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标签名字',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `status` int(11) NULL DEFAULT NULL COMMENT '停启状态(1是正常，0是禁用)',
  `deleted` int(11) NOT NULL DEFAULT 0 COMMENT '逻辑删除 1代表删除 0代表未删除',
  `project_id` bigint(11) NOT NULL DEFAULT 0 COMMENT '0是公共标签，其他是私有标签',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `user_id` bigint(11) NOT NULL COMMENT '创建人id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_relation_label
-- ----------------------------

-- ----------------------------
-- Table structure for t_relation_pattern
-- ----------------------------
DROP TABLE IF EXISTS `t_relation_pattern`;
CREATE TABLE `t_relation_pattern`  (
  `id` bigint(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '关系模板名称',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `schema_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '模板JSON',
  `status` int(11) NOT NULL DEFAULT 0 COMMENT '停启状态(1是正常，0是禁用)',
  `image` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT '图片的base64编码',
  `order_num` int(11) NULL DEFAULT NULL COMMENT '排序字段',
  `project_id` bigint(11) NULL DEFAULT 0 COMMENT '0是公共标签，其他是私有标签',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `deleted` int(11) NOT NULL DEFAULT 0 COMMENT '逻辑删除 1代表删除 0代表未删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_relation_pattern
-- ----------------------------

-- ----------------------------
-- Table structure for t_semantic_types
-- ----------------------------
DROP TABLE IF EXISTS `t_semantic_types`;
CREATE TABLE `t_semantic_types`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `simple` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_semantic_types
-- ----------------------------

-- ----------------------------
-- Table structure for t_umls_concept
-- ----------------------------
DROP TABLE IF EXISTS `t_umls_concept`;
CREATE TABLE `t_umls_concept`  (
  `id` bigint(11) NOT NULL AUTO_INCREMENT,
  `concept_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标签id',
  `concept_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标签名字',
  `semantic_types` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'semantic_types',
  `preferred_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'preferred_name',
  `status` int(11) NULL DEFAULT NULL COMMENT '停启状态(1是正常，0是禁用)',
  `creater` int(11) NULL DEFAULT NULL COMMENT '创建人id',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `project_id` bigint(20) NOT NULL DEFAULT 0 COMMENT '所属项目id',
  `deleted` int(11) NOT NULL DEFAULT 0 COMMENT '逻辑删除 1代表删除 0代表未删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_umls_concept
-- ----------------------------

-- ----------------------------
-- Table structure for t_verify_label
-- ----------------------------
DROP TABLE IF EXISTS `t_verify_label`;
CREATE TABLE `t_verify_label`  (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `verify_task_id` int(20) NOT NULL COMMENT 'ID',
  `type` tinyint(1) NULL DEFAULT NULL COMMENT '1 2',
  `label_id` bigint(11) NOT NULL,
  `label_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `entity_total` int(11) NULL DEFAULT NULL,
  `need_total` int(11) NULL DEFAULT 0,
  `correct_total` int(11) NULL DEFAULT NULL,
  `error_total` int(11) NULL DEFAULT 0,
  `miss_total` int(11) NULL DEFAULT 0,
  `deleted` tinyint(2) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `verify_task_id`(`verify_task_id`) USING BTREE,
  INDEX `type`(`type`) USING BTREE,
  INDEX `label_id`(`label_id`) USING BTREE,
  INDEX `deleted`(`deleted`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_verify_label
-- ----------------------------

-- ----------------------------
-- Table structure for t_verify_task
-- ----------------------------
DROP TABLE IF EXISTS `t_verify_task`;
CREATE TABLE `t_verify_task`  (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `project_id` int(20) NOT NULL COMMENT 'ID',
  `pre_source_id` int(20) NULL DEFAULT NULL COMMENT 'ID',
  `batch_id` int(20) NULL DEFAULT NULL COMMENT 'ID',
  `task_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `status` int(2) NOT NULL DEFAULT 1,
  `creator` bigint(20) NOT NULL,
  `create_time` datetime NOT NULL,
  `update_time` datetime NOT NULL,
  `finish_time` datetime NULL DEFAULT NULL,
  `deleted` tinyint(2) NOT NULL DEFAULT 0,
  `method` int(11) NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `project_id`(`project_id`) USING BTREE,
  INDEX `task_name`(`task_name`) USING BTREE,
  INDEX `status`(`status`) USING BTREE,
  INDEX `deleted`(`deleted`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_verify_task
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
