-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 05-03-2026 a las 16:20:14
-- Versión del servidor: 11.8.6-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `matriz_riesgo`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `areas`
--

CREATE TABLE `areas` (
  `id_area` int(11) NOT NULL,
  `id_sede` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `estado` enum('activo','inactivo') DEFAULT 'activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Volcado de datos para la tabla `areas`
--

INSERT INTO `areas` (`id_area`, `id_sede`, `nombre`, `descripcion`, `estado`) VALUES
(1, 1, 'Prueba', 'Área destinada a pruebas técnicas y validación de procesos internos.', 'activo'),
(2, 1, 'Sistemas', 'Área encargada de la administración tecnológica e infraestructura TI.', 'activo'),
(3, 4, 'Default Area', NULL, 'activo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auditoria`
--

CREATE TABLE `auditoria` (
  `id_auditoria` int(11) NOT NULL,
  `tabla_afectada` varchar(100) NOT NULL,
  `id_registro` int(11) NOT NULL,
  `accion` varchar(50) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `fecha_hora` timestamp NULL DEFAULT current_timestamp(),
  `ip_origen` varchar(45) DEFAULT NULL,
  `descripcion` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Volcado de datos para la tabla `auditoria`
--

INSERT INTO `auditoria` (`id_auditoria`, `tabla_afectada`, `id_registro`, `accion`, `id_usuario`, `fecha_hora`, `ip_origen`, `descripcion`) VALUES
(1, 'test_insert', 99998, 'INSERT', 1, '2026-02-28 02:30:36', '127.0.0.1', NULL),
(2, 'items_riesgos', 3, 'UPDATE', 2, '2026-02-28 02:31:51', '127.0.0.1', NULL),
(3, 'items_riesgos', 3, 'EDITAR', 2, '2026-02-28 02:45:42', '127.0.0.1', 'Editado: descripcion: \'blablablabla\' -> \'blablablabla\'; criticidad: \'3\' -> \'3\'; estado: \'1\' -> \'1\''),
(4, 'riesgos', 1, 'EDITAR', 2, '2026-02-28 02:46:18', '127.0.0.1', 'Editado: descripcion: \'Posible daño en componentes físicos del equipo. Revisar\' -> \'Posible daño en componentes físicos del equipo. Revisar\'; nivel_riesgo: \'3\' -> \'3\'; estado: \'1\' -> \'1\''),
(5, 'items_riesgos', 1, 'EDITAR', 2, '2026-02-28 02:47:13', '127.0.0.1', 'Editado: id_area: \'Prueba\' -> \'Prueba\'; criticidad: \'3\' -> \'3\'; estado: \'1\' -> \'1\''),
(6, 'item_responsable', 4, 'ASIGNAR', 2, '2026-02-28 02:58:19', '127.0.0.1', NULL),
(7, 'registro_checks', 3, 'CREAR', 2, '2026-02-28 02:58:31', '127.0.0.1', 'Chequeo control id=2 nombre=Actualización de Antivirus usuario=Raveadmin fecha=2026-02-27'),
(8, 'items_riesgos', 1, 'EDITAR', 3, '2026-02-28 03:00:36', '127.0.0.1', 'Editado: criticidad: \'2\' -> \'2\'; estado: \'0\' -> \'0\''),
(9, 'registro_checks', 4, 'CREAR', 3, '2026-02-28 03:05:14', '127.0.0.1', 'Chequeo control id=2 nombre=Actualización de Antivirus usuario=Andrés Torres fecha=2026-02-27'),
(10, 'registro_checks', 5, 'CREAR', 2, '2026-02-28 03:05:29', '127.0.0.1', 'Chequeo control id=1 nombre=Mantenimiento Preventivo usuario=Raveadmin fecha=2026-02-27'),
(11, 'riesgos', 1, 'EDITAR', 2, '2026-02-28 03:21:18', '127.0.0.1', 'Riesgo \"Falla de Hardware\" identificado \"1\" fue editado por \"Raveadmin\": Nivel: \"3\" -> \"3\"; Estado: \"0\" -> \"0\"'),
(12, 'riesgos', 1, 'EDITAR', 2, '2026-02-28 03:21:27', '127.0.0.1', 'Riesgo \"Falla de Hardware\" identificado \"1\" fue editado por \"Raveadmin\": Nivel: \"3\" -> \"3\"; Estado: \"0\" -> \"0\"'),
(13, 'riesgos', 1, 'EDITAR', 2, '2026-02-28 03:36:20', '127.0.0.1', 'Riesgo \"Falla de Hardware\" identificado \"1\" fue editado por \"Raveadmin\": Nivel: \"3\" -> \"3\"; Estado: \"0\" -> \"0\"'),
(14, 'registro_checks', 6, 'CREAR', 2, '2026-03-02 20:54:02', '127.0.0.1', 'Control \"Mantenimiento Preventivo\" identificado \"1\" fue marcado por \"Raveadmin\" el dia \"2026-03-02\". Observaciones: \"Hoy esta bien\"'),
(15, 'controles', 1, 'INSPECCION', 2, '2026-03-03 03:15:21', '127.0.0.1', 'Control \"Mantenimiento Preventivo\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-02\".'),
(16, 'controles', 2, 'INSPECCION', 2, '2026-03-03 03:15:28', '127.0.0.1', 'Control \"Actualización de Antivirus\" identificado \"2\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-02\".'),
(17, 'riesgos', 1, 'INSPECCION', 2, '2026-03-03 18:37:06', '127.0.0.1', 'Riesgo \"Falla de Hardware\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-03\".'),
(18, 'items_riesgos', 1, 'INSPECCION', 2, '2026-03-03 18:39:32', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-03\".'),
(19, 'item_responsable', 1, 'INSPECCION', 2, '2026-03-03 18:43:00', '127.0.0.1', 'Asignación del item \"Equipo de Cómputo - PC Administrativo\" al usuario \"Andrés Torres\" (id 1) fue inspeccionada por \"Raveadmin\" el dia \"2026-03-03\".'),
(20, 'item_responsable', 1, 'INSPECCION', 2, '2026-03-03 18:43:21', '127.0.0.1', 'Asignación del item \"Equipo de Cómputo - PC Administrativo\" al usuario \"Andrés Torres\" (id 1) fue inspeccionada por \"Raveadmin\" el dia \"2026-03-03\".'),
(21, 'controles', 1, 'INSPECCION', 2, '2026-03-03 18:44:02', '127.0.0.1', 'Control \"Mantenimiento Preventivo\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-03\".'),
(22, 'controles', 1, 'INSPECCION', 2, '2026-03-03 18:44:33', '127.0.0.1', 'Control \"Mantenimiento Preventivo\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-03\".'),
(23, 'item_responsable', 1, 'INSPECCION', 2, '2026-03-03 18:46:27', '127.0.0.1', 'Asignación del item \"Equipo de Cómputo - PC Administrativo\" al usuario \"Andrés Torres\" (id 1) fue inspeccionada por \"Raveadmin\" el dia \"2026-03-03\".'),
(24, 'items_riesgos', 1, 'INSPECCION', 2, '2026-03-03 19:22:29', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-03\".'),
(25, 'riesgos', 1, 'INSPECCION', 2, '2026-03-03 19:22:33', '127.0.0.1', 'Riesgo \"Falla de Hardware\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-03\".'),
(26, 'items_riesgos', 1, 'INSPECCION', 3, '2026-03-03 21:27:13', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(27, 'items_riesgos', 1, 'INSPECCION', 3, '2026-03-03 21:27:46', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(28, 'items_riesgos', 1, 'INSPECCION', 3, '2026-03-03 21:28:12', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(29, 'items_riesgos', 1, 'INSPECCION', 3, '2026-03-03 21:28:21', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(30, 'items_riesgos', 1, 'INSPECCION', 3, '2026-03-03 21:33:51', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(31, 'items_riesgos', 1, 'INSPECCION', 3, '2026-03-03 21:41:52', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(32, 'riesgos', 1, 'INSPECCION', 3, '2026-03-03 21:44:27', '127.0.0.1', 'Riesgo \"Falla de Hardware\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(33, 'riesgos', 1, 'INSPECCION', 3, '2026-03-03 21:45:04', '127.0.0.1', 'Riesgo \"Falla de Hardware\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(34, 'riesgos', 2, 'INSPECCION', 3, '2026-03-03 21:46:43', '127.0.0.1', 'Riesgo \"Infección por Malware\" identificado \"2\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(35, 'riesgos', 2, 'INSPECCION', 3, '2026-03-03 21:47:44', '127.0.0.1', 'Riesgo \"Infección por Malware\" identificado \"2\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(36, 'controles', 1, 'INSPECCION', 3, '2026-03-03 21:58:02', '127.0.0.1', 'Control \"Mantenimiento Preventivo\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(37, 'item_responsable', 1, 'INSPECCION', 3, '2026-03-04 00:24:13', '127.0.0.1', 'Asignación del item \"Equipo de Cómputo - PC Administrativo\" al usuario \"Andrés Torres\" (id 1) fue inspeccionada por \"Andrés Torres\" el dia \"2026-03-03\".'),
(38, 'item_responsable', 1, 'INSPECCION', 3, '2026-03-04 00:24:18', '127.0.0.1', 'Asignación del item \"Equipo de Cómputo - PC Administrativo\" al usuario \"Andrés Torres\" (id 1) fue inspeccionada por \"Andrés Torres\" el dia \"2026-03-03\".'),
(39, 'item_responsable', 1, 'INSPECCION', 3, '2026-03-04 00:31:26', '127.0.0.1', 'Asignación del item \"Equipo de Cómputo - PC Administrativo\" al usuario \"Andrés Torres\" (id 1) fue inspeccionada por \"Andrés Torres\" el dia \"2026-03-03\".'),
(40, 'controles', 2, 'INSPECCION', 3, '2026-03-04 00:31:43', '127.0.0.1', 'Control \"Actualización de Antivirus\" identificado \"2\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(41, 'riesgos', 1, 'INSPECCION', 3, '2026-03-04 00:31:49', '127.0.0.1', 'Riesgo \"Falla de Hardware\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(42, 'items_riesgos', 1, 'INSPECCION', 3, '2026-03-04 00:31:53', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(43, 'controles', 3, 'CREAR', 3, '2026-03-04 00:49:10', '127.0.0.1', 'Control \"Revisar Spam de Correo\" identificado \"3\" fue creado por \"Andrés Torres\". Riesgo: \"Infección por Malware\". Frecuencia: \"DIARIO\". Estado: \"Activo\".'),
(44, 'registro_checks', 7, 'CREAR', 3, '2026-03-04 00:49:26', '127.0.0.1', 'Control \"Mantenimiento Preventivo\" identificado \"1\" fue marcado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(45, 'registro_checks', 8, 'CREAR', 3, '2026-03-04 01:05:04', '127.0.0.1', 'Control \"Revisar Spam de Correo\" identificado \"3\" fue marcado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(46, 'items_riesgos', 1, 'INSPECCION', 3, '2026-03-04 01:08:51', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(47, 'item_responsable', 1, 'INSPECCION', 3, '2026-03-04 01:17:43', '127.0.0.1', 'Asignación del item \"Equipo de Cómputo - PC Administrativo\" al usuario \"Andrés Torres\" (id 1) fue inspeccionada por \"Andrés Torres\" el dia \"2026-03-03\".'),
(48, 'items_riesgos', 1, 'INSPECCION', 3, '2026-03-04 01:19:03', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(49, 'item_responsable', 5, 'ASIGNAR', 3, '2026-03-04 01:39:13', '127.0.0.1', 'Asignación creada: item \"Equipo de Cómputo - PC Administrativo\" asignado a \"Andrés Torres\" por \"Andrés Torres\".'),
(50, 'item_responsable', 6, 'ASIGNAR', 3, '2026-03-04 01:41:26', '127.0.0.1', 'Asignación creada: item \"Equipo de Cómputo - PC Administrativo\" asignado a \"Andrés Torres\" por \"Andrés Torres\".'),
(51, 'item_responsable', 7, 'ASIGNAR', 3, '2026-03-04 01:44:01', '127.0.0.1', 'Asignación creada: item \"Prueba\" asignado a \"Andrés Torres\" por \"Andrés Torres\".'),
(52, 'items_riesgos', 1, 'INSPECCION', 3, '2026-03-04 01:55:43', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(53, 'items_riesgos', 1, 'INSPECCION', 3, '2026-03-04 01:55:50', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(54, 'controles', 1, 'EDITAR', 3, '2026-03-04 01:59:39', '127.0.0.1', 'Control \"Mantenimiento Preventivo\" identificado \"1\" fue editado por \"Andrés Torres\": Estado: \"0\" -> \"0\"'),
(55, 'item_responsable', 7, 'EDITAR', 3, '2026-03-04 02:04:09', '127.0.0.1', 'Asignación id 7 (item \"Prueba\" a \"Andrés Torres\") fue editada por \"Andrés Torres\".'),
(56, 'registro_checks', 8, 'INSPECCION', 3, '2026-03-04 02:38:40', '127.0.0.1', 'RegistroCheck id 8 inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(57, 'registro_checks', 4, 'INSPECCION', 3, '2026-03-04 02:38:49', '127.0.0.1', 'RegistroCheck id 4 inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(58, 'registro_checks', 2, 'INSPECCION', 3, '2026-03-04 02:38:51', '127.0.0.1', 'RegistroCheck id 2 inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(59, 'registro_checks', 2, 'INSPECCION', 3, '2026-03-04 02:38:54', '127.0.0.1', 'RegistroCheck id 2 inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(60, 'controles', 1, 'EDITAR', 3, '2026-03-04 02:42:41', '127.0.0.1', 'Control \"Mantenimiento Preventivo\" identificado \"1\" fue editado por \"Andrés Torres\": Estado: \"inactivo\" -> \"inactivo\"'),
(61, 'items_riesgos', 1, 'EDITAR', 3, '2026-03-04 02:43:13', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue editado por \"Andrés Torres\": Criticidad: \"3\" -> \"3\"; Estado: \"inactivo\" -> \"inactivo\"'),
(62, 'items_riesgos', 1, 'EDITAR', 3, '2026-03-04 02:50:24', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue editado por \"Andrés Torres\": Criticidad: \"3\" -> \"3\"; Estado: \"activo\" -> \"activo\"'),
(63, 'items_riesgos', 1, 'EDITAR', 3, '2026-03-04 02:50:28', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue editado por \"Andrés Torres\": Criticidad: \"2\" -> \"2\"'),
(64, 'registro_checks', 9, 'CREAR', 3, '2026-03-04 02:50:45', '127.0.0.1', 'Control \"Actualización de Antivirus\" identificado \"2\" fue marcado por \"Andrés Torres\" el dia \"2026-03-03\". Observaciones: \"Todo correcto prueba de cantidad de texto aaaaaaaaaaaaaabbbbbbbbbbbcccccccccc\"'),
(65, 'registro_checks', 9, 'INSPECCION', 3, '2026-03-04 02:53:44', '127.0.0.1', 'RegistroCheck id 9 inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(66, 'item_responsable', 7, 'EDITAR', 3, '2026-03-04 02:54:21', '127.0.0.1', 'Asignación id 7 (item \"Prueba\" a \"Andrés Torres\") fue editada por \"Andrés Torres\".'),
(67, 'item_responsable', 6, 'EDITAR', 3, '2026-03-04 02:54:29', '127.0.0.1', 'Asignación id 6 (item \"Equipo de Cómputo - PC Administrativo\" a \"Andrés Torres\") fue editada por \"Andrés Torres\".'),
(68, 'item_responsable', 6, 'EDITAR', 3, '2026-03-04 02:58:14', '127.0.0.1', 'Asignación id 6 (item \"Equipo de Cómputo - PC Administrativo\" a \"Andrés Torres\") fue editada por \"Andrés Torres\".'),
(69, 'items_riesgos', 1, 'INSPECCION', 3, '2026-03-04 02:58:44', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(70, 'riesgos', 1, 'INSPECCION', 3, '2026-03-04 02:59:30', '127.0.0.1', 'Riesgo \"Falla de Hardware\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(71, 'controles', 1, 'INSPECCION', 3, '2026-03-04 02:59:49', '127.0.0.1', 'Control \"Mantenimiento Preventivo\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(72, 'item_responsable', 2, 'INSPECCION', 3, '2026-03-04 03:00:19', '127.0.0.1', 'Asignación del item \"Equipo de Cómputo - PC Administrativo\" al usuario \"Mariana Ríos\" (id 2) fue inspeccionada por \"Andrés Torres\" el dia \"2026-03-03\".'),
(73, 'item_responsable', 2, 'INSPECCION', 3, '2026-03-04 03:00:44', '127.0.0.1', 'Asignación del item \"Equipo de Cómputo - PC Administrativo\" al usuario \"Mariana Ríos\" (id 2) fue inspeccionada por \"Andrés Torres\" el dia \"2026-03-03\".'),
(74, 'registro_checks', 9, 'INSPECCION', 3, '2026-03-04 03:01:19', '127.0.0.1', 'RegistroCheck id 9 inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(75, 'item_responsable', 2, 'INSPECCION', 3, '2026-03-04 03:01:46', '127.0.0.1', 'Asignación del item \"Equipo de Cómputo - PC Administrativo\" al usuario \"Mariana Ríos\" (id 2) fue inspeccionada por \"Andrés Torres\" el dia \"2026-03-03\".'),
(76, 'item_responsable', 2, 'INSPECCION', 3, '2026-03-04 03:05:42', '127.0.0.1', 'Asignación del item \"Equipo de Cómputo - PC Administrativo\" al usuario \"Mariana Ríos\" (id 2) fue inspeccionada por \"Andrés Torres\" el dia \"2026-03-03\".'),
(77, 'items_riesgos', 1, 'INSPECCION', 3, '2026-03-04 03:05:45', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(78, 'item_responsable', 2, 'INSPECCION', 3, '2026-03-04 03:06:09', '127.0.0.1', 'Asignación del item \"Equipo de Cómputo - PC Administrativo\" al usuario \"Mariana Ríos\" (id 2) fue inspeccionada por \"Andrés Torres\" el dia \"2026-03-03\".'),
(79, 'riesgos', 1, 'INSPECCION', 3, '2026-03-04 03:06:19', '127.0.0.1', 'Riesgo \"Falla de Hardware\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(80, 'riesgos', 1, 'INSPECCION', 3, '2026-03-04 03:07:59', '127.0.0.1', 'Riesgo \"Falla de Hardware\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(81, 'items_riesgos', 1, 'INSPECCION', 3, '2026-03-04 03:08:02', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(82, 'items_riesgos', 1, 'INSPECCION', 3, '2026-03-04 03:08:28', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(83, 'items_riesgos', 1, 'INSPECCION', 3, '2026-03-04 03:08:29', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(84, 'items_riesgos', 1, 'INSPECCION', 3, '2026-03-04 03:10:51', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(85, 'items_riesgos', 1, 'INSPECCION', 3, '2026-03-04 03:10:52', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(86, 'items_riesgos', 1, 'INSPECCION', 3, '2026-03-04 03:10:52', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(87, 'items_riesgos', 1, 'INSPECCION', 3, '2026-03-04 03:10:53', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(88, 'items_riesgos', 1, 'INSPECCION', 3, '2026-03-04 03:10:53', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(89, 'items_riesgos', 1, 'INSPECCION', 3, '2026-03-04 03:14:59', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(90, 'items_riesgos', 1, 'INSPECCION', 3, '2026-03-04 03:15:04', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(91, 'controles', 1, 'INSPECCION', 3, '2026-03-04 03:22:13', '127.0.0.1', 'Control \"Mantenimiento Preventivo\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(92, 'controles', 1, 'INSPECCION', 3, '2026-03-04 03:22:15', '127.0.0.1', 'Control \"Mantenimiento Preventivo\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(93, 'controles', 1, 'INSPECCION', 3, '2026-03-04 03:22:16', '127.0.0.1', 'Control \"Mantenimiento Preventivo\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(94, 'items_riesgos', 1, 'INSPECCION', 3, '2026-03-04 03:27:50', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(95, 'items_riesgos', 1, 'INSPECCION', 3, '2026-03-04 03:27:51', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(96, 'items_riesgos', 1, 'INSPECCION', 3, '2026-03-04 03:27:52', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(97, 'riesgos', 1, 'INSPECCION', 3, '2026-03-04 03:28:03', '127.0.0.1', 'Riesgo \"Falla de Hardware\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(98, 'riesgos', 1, 'INSPECCION', 3, '2026-03-04 03:28:04', '127.0.0.1', 'Riesgo \"Falla de Hardware\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(99, 'registro_checks', 9, 'INSPECCION', 3, '2026-03-04 03:28:17', '127.0.0.1', 'RegistroCheck id 9 inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(100, 'registro_checks', 9, 'INSPECCION', 3, '2026-03-04 03:28:18', '127.0.0.1', 'RegistroCheck id 9 inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(101, 'registro_checks', 9, 'INSPECCION', 3, '2026-03-04 03:28:19', '127.0.0.1', 'RegistroCheck id 9 inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(102, 'registro_checks', 9, 'INSPECCION', 3, '2026-03-04 03:37:41', '127.0.0.1', 'RegistroCheck id 9 inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(103, 'registro_checks', 9, 'INSPECCION', 3, '2026-03-04 03:37:42', '127.0.0.1', 'RegistroCheck id 9 inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(104, 'registro_checks', 9, 'INSPECCION', 3, '2026-03-04 03:37:43', '127.0.0.1', 'RegistroCheck id 9 inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(105, 'controles', 1, 'INSPECCION', 3, '2026-03-04 03:37:52', '127.0.0.1', 'Control \"Mantenimiento Preventivo\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(106, 'controles', 1, 'INSPECCION', 3, '2026-03-04 03:37:53', '127.0.0.1', 'Control \"Mantenimiento Preventivo\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(107, 'controles', 1, 'INSPECCION', 3, '2026-03-04 03:37:54', '127.0.0.1', 'Control \"Mantenimiento Preventivo\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(108, 'registro_checks', 8, 'INSPECCION', 2, '2026-03-04 03:43:20', '127.0.0.1', 'RegistroCheck id 8 inspeccionado por \"Raveadmin\" el dia \"2026-03-03\".'),
(109, 'registro_checks', 8, 'INSPECCION', 2, '2026-03-04 03:43:21', '127.0.0.1', 'RegistroCheck id 8 inspeccionado por \"Raveadmin\" el dia \"2026-03-03\".'),
(110, 'registro_checks', 8, 'INSPECCION', 2, '2026-03-04 03:43:23', '127.0.0.1', 'RegistroCheck id 8 inspeccionado por \"Raveadmin\" el dia \"2026-03-03\".'),
(111, 'registro_checks', 9, 'INSPECCION', 2, '2026-03-04 03:55:15', '127.0.0.1', 'RegistroCheck id 9 inspeccionado por \"Raveadmin\" el dia \"2026-03-03\".'),
(112, 'registro_checks', 9, 'INSPECCION', 2, '2026-03-04 03:55:17', '127.0.0.1', 'RegistroCheck id 9 inspeccionado por \"Raveadmin\" el dia \"2026-03-03\".'),
(113, 'registro_checks', 9, 'INSPECCION', 2, '2026-03-04 03:55:17', '127.0.0.1', 'RegistroCheck id 9 inspeccionado por \"Raveadmin\" el dia \"2026-03-03\".'),
(114, 'registro_checks', 9, 'INSPECCION', 2, '2026-03-04 03:55:17', '127.0.0.1', 'RegistroCheck id 9 inspeccionado por \"Raveadmin\" el dia \"2026-03-03\".'),
(115, 'items_riesgos', 1, 'INSPECCION', 2, '2026-03-04 04:02:56', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-03\".'),
(116, 'items_riesgos', 1, 'INSPECCION', 2, '2026-03-04 04:02:57', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-03\".'),
(117, 'items_riesgos', 1, 'INSPECCION', 2, '2026-03-04 04:02:57', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-03\".'),
(118, 'items_riesgos', 1, 'INSPECCION', 2, '2026-03-04 04:02:57', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-03\".'),
(119, 'items_riesgos', 1, 'INSPECCION', 2, '2026-03-04 04:32:03', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-03\".'),
(120, 'registro_checks', 9, 'INSPECCION', 2, '2026-03-04 04:32:17', '127.0.0.1', 'RegistroCheck id 9 inspeccionado por \"Raveadmin\" el dia \"2026-03-03\".'),
(121, 'registro_checks', 9, 'INSPECCION', 2, '2026-03-04 04:32:18', '127.0.0.1', 'RegistroCheck id 9 inspeccionado por \"Raveadmin\" el dia \"2026-03-03\".'),
(122, 'registro_checks', 9, 'INSPECCION', 2, '2026-03-04 04:32:18', '127.0.0.1', 'RegistroCheck id 9 inspeccionado por \"Raveadmin\" el dia \"2026-03-03\".'),
(123, 'registro_checks', 9, 'INSPECCION', 2, '2026-03-04 04:32:19', '127.0.0.1', 'RegistroCheck id 9 inspeccionado por \"Raveadmin\" el dia \"2026-03-03\".'),
(124, 'registro_checks', 9, 'INSPECCION', 2, '2026-03-04 04:32:19', '127.0.0.1', 'RegistroCheck id 9 inspeccionado por \"Raveadmin\" el dia \"2026-03-03\".'),
(125, 'registro_checks', 9, 'INSPECCION', 2, '2026-03-04 04:32:20', '127.0.0.1', 'RegistroCheck id 9 inspeccionado por \"Raveadmin\" el dia \"2026-03-03\".'),
(126, 'items_riesgos', 1, 'INSPECCION', 2, '2026-03-04 04:44:18', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-03\".'),
(127, 'riesgos', 1, 'INSPECCION', 2, '2026-03-04 04:44:26', '127.0.0.1', 'Riesgo \"Falla de Hardware\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-03\".'),
(128, 'items_riesgos', 1, 'INSPECCION', 2, '2026-03-04 04:44:54', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-03\".'),
(129, 'item_responsable', 2, 'INSPECCION', 2, '2026-03-04 04:44:56', '127.0.0.1', 'Asignación del item \"Equipo de Cómputo - PC Administrativo\" al usuario \"Mariana Ríos\" (id 2) fue inspeccionada por \"Raveadmin\" el dia \"2026-03-03\".'),
(130, 'registro_checks', 9, 'INSPECCION', 2, '2026-03-04 04:45:15', '127.0.0.1', 'RegistroCheck id 9 inspeccionado por \"Raveadmin\" el dia \"2026-03-03\".'),
(131, 'item_responsable', 2, 'INSPECCION', 2, '2026-03-04 04:46:36', '127.0.0.1', 'Asignación del item \"Equipo de Cómputo - PC Administrativo\" al usuario \"Mariana Ríos\" (id 2) fue inspeccionada por \"Raveadmin\" el dia \"2026-03-03\".'),
(132, 'item_responsable', 2, 'INSPECCION', 2, '2026-03-04 04:52:32', '127.0.0.1', 'Asignación del item \"Equipo de Cómputo - PC Administrativo\" al usuario \"Mariana Ríos\" (id 2) fue inspeccionada por \"Raveadmin\" el dia \"2026-03-03\".'),
(133, 'item_responsable', 2, 'INSPECCION', 2, '2026-03-04 04:52:43', '127.0.0.1', 'Asignación del item \"Equipo de Cómputo - PC Administrativo\" al usuario \"Mariana Ríos\" (id 2) fue inspeccionada por \"Raveadmin\" el dia \"2026-03-03\".'),
(134, 'registro_checks', 9, 'INSPECCION', 2, '2026-03-04 04:52:57', '127.0.0.1', 'RegistroCheck id 9 inspeccionado por \"Raveadmin\" el dia \"2026-03-03\".'),
(135, 'registro_checks', 9, 'INSPECCION', 3, '2026-03-04 04:53:35', '127.0.0.1', 'RegistroCheck id 9 inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(136, 'item_responsable', 2, 'EDITAR', 3, '2026-03-04 04:57:14', '127.0.0.1', 'Asignación id 2 (item \"Prueba\" a \"Mariana Ríos\") fue editada por \"Andrés Torres\".'),
(137, 'registro_checks', 9, 'INSPECCION', 3, '2026-03-04 04:58:13', '127.0.0.1', 'RegistroCheck id 9 inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(138, 'item_responsable', 2, 'INSPECCION', 3, '2026-03-04 04:58:23', '127.0.0.1', 'Asignación del item \"Prueba\" al usuario \"Mariana Ríos\" (id 2) fue inspeccionada por \"Andrés Torres\" el dia \"2026-03-03\".'),
(139, 'item_responsable', 2, 'INSPECCION', 3, '2026-03-04 04:58:29', '127.0.0.1', 'Asignación del item \"Prueba\" al usuario \"Mariana Ríos\" (id 2) fue inspeccionada por \"Andrés Torres\" el dia \"2026-03-03\".'),
(140, 'controles', 1, 'INSPECCION', 3, '2026-03-04 04:58:39', '127.0.0.1', 'Control \"Mantenimiento Preventivo\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(141, 'riesgos', 1, 'INSPECCION', 3, '2026-03-04 04:58:52', '127.0.0.1', 'Riesgo \"Falla de Hardware\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(142, 'items_riesgos', 1, 'INSPECCION', 3, '2026-03-04 04:59:01', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(143, 'item_responsable', 2, 'EDITAR', 3, '2026-03-04 05:00:16', '127.0.0.1', 'Asignación id 2 (item \"Equipo de Cómputo - PC Administrativo\" a \"Mariana Ríos\") fue editada por \"Andrés Torres\".'),
(144, 'riesgos', 1, 'EDITAR', 3, '2026-03-04 05:00:41', '127.0.0.1', 'Riesgo \"Falla de Hardware\" identificado \"1\" fue editado por \"Andrés Torres\": Nivel: \"3\" -> \"3\"; Estado: \"inactivo\" -> \"inactivo\"'),
(145, 'riesgos', 1, 'EDITAR', 3, '2026-03-04 05:01:04', '127.0.0.1', 'Riesgo \"Falla de Hardware\" identificado \"1\" fue editado por \"Andrés Torres\": Nivel: \"3\" -> \"3\"; Estado: \"activo\" -> \"activo\"'),
(146, 'controles', 1, 'EDITAR', 3, '2026-03-04 05:01:27', '127.0.0.1', 'Control \"Mantenimiento Preventivo\" identificado \"1\" fue editado por \"Andrés Torres\": Estado: \"activo\" -> \"activo\"'),
(147, 'items_riesgos', 5, 'CREAR', 3, '2026-03-04 05:05:21', '127.0.0.1', 'Item \"CELULAR DE ENDER\" identificado \"5\" fue creado por \"Andrés Torres\". Área: \"Prueba\". Criticidad: \"Medio\". Estado: \"Activo\".'),
(148, 'riesgos', 4, 'CREAR', 3, '2026-03-04 05:06:25', '127.0.0.1', 'Riesgo \"Recalentamiento por Juegos\" identificado \"4\" fue creado por \"Andrés Torres\". Item: \"CELULAR DE ENDER\". Nivel: \"Alto\". Estado: \"Activo\".'),
(149, 'controles', 4, 'CREAR', 3, '2026-03-04 05:06:55', '127.0.0.1', 'Control \"Refrigeración al Celular\" identificado \"4\" fue creado por \"Andrés Torres\". Riesgo: \"Recalentamiento por Juegos\". Frecuencia: \"DIARIO\". Estado: \"Activo\".'),
(150, 'item_responsable', 8, 'ASIGNAR', 3, '2026-03-04 05:07:31', '127.0.0.1', 'Asignación creada: item \"CELULAR DE ENDER\" asignado a \"Andrés Torres\" por \"Andrés Torres\".'),
(151, 'items_riesgos', 5, 'EDITAR', 3, '2026-03-04 05:07:53', '127.0.0.1', 'Item \"CELULAR DE ENDER\" identificado \"5\" fue editado por \"Andrés Torres\": Criticidad: \"3\" -> \"3\"; Estado: \"inactivo\" -> \"inactivo\"'),
(152, 'items_riesgos', 5, 'EDITAR', 3, '2026-03-04 05:08:02', '127.0.0.1', 'Item \"CELULAR DE ENDER\" identificado \"5\" fue editado por \"Andrés Torres\": Criticidad: \"3\" -> \"3\"; Estado: \"activo\" -> \"activo\"'),
(153, 'riesgos', 4, 'EDITAR', 3, '2026-03-04 05:08:38', '127.0.0.1', 'Riesgo \"Recalentamiento por Juegos\" identificado \"4\" fue editado por \"Andrés Torres\": Nivel: \"3\" -> \"3\"; Estado: \"inactivo\" -> \"inactivo\"'),
(154, 'riesgos', 4, 'EDITAR', 3, '2026-03-04 05:09:31', '127.0.0.1', 'Riesgo \"Recalentamiento por Juegos\" identificado \"4\" fue editado por \"Andrés Torres\": Nivel: \"3\" -> \"3\"; Estado: \"activo\" -> \"activo\"'),
(155, 'controles', 4, 'EDITAR', 3, '2026-03-04 05:09:37', '127.0.0.1', 'Control \"Refrigeración al Celular\" identificado \"4\" fue editado por \"Andrés Torres\": Estado: \"inactivo\" -> \"inactivo\"'),
(156, 'controles', 4, 'EDITAR', 3, '2026-03-04 05:09:49', '127.0.0.1', 'Control \"Refrigeración al Celular\" identificado \"4\" fue editado por \"Andrés Torres\": Estado: \"activo\" -> \"activo\"'),
(157, 'controles', 4, 'EDITAR', 3, '2026-03-04 05:10:32', '127.0.0.1', 'Control \"Refrigeración al Celular\" identificado \"4\" fue editado por \"Andrés Torres\": Estado: \"inactivo\" -> \"inactivo\"'),
(158, 'controles', 4, 'EDITAR', 3, '2026-03-04 05:10:36', '127.0.0.1', 'Control \"Refrigeración al Celular\" identificado \"4\" fue editado por \"Andrés Torres\": Estado: \"activo\" -> \"activo\"'),
(159, 'registro_checks', 9, 'INSPECCION', 3, '2026-03-04 05:18:38', '127.0.0.1', 'RegistroCheck id 9 inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(160, 'registro_checks', 9, 'INSPECCION', 3, '2026-03-04 05:18:51', '127.0.0.1', 'RegistroCheck id 9 inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(161, 'item_responsable', 2, 'INSPECCION', 3, '2026-03-04 05:18:55', '127.0.0.1', 'Asignación del item \"Equipo de Cómputo - PC Administrativo\" al usuario \"Mariana Ríos\" (id 2) fue inspeccionada por \"Andrés Torres\" el dia \"2026-03-03\".'),
(162, 'controles', 1, 'INSPECCION', 3, '2026-03-04 05:19:03', '127.0.0.1', 'Control \"Mantenimiento Preventivo\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(163, 'riesgos', 1, 'INSPECCION', 3, '2026-03-04 05:19:12', '127.0.0.1', 'Riesgo \"Falla de Hardware\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(164, 'items_riesgos', 1, 'INSPECCION', 3, '2026-03-04 05:19:18', '127.0.0.1', 'Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(165, 'items_riesgos', 3, 'INSPECCION', 3, '2026-03-04 05:20:26', '127.0.0.1', 'Item \"Prueba\" identificado \"3\" fue inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(166, 'items_riesgos', 5, 'EDITAR', 3, '2026-03-04 05:42:56', '127.0.0.1', 'Item \"CELULAR DE ENDER\" identificado \"5\" fue editado por \"Andrés Torres\": Área: \"Sistemas\" -> \"Sistemas\"; Criticidad: \"3\" -> \"3\"'),
(167, 'registro_checks', 9, 'INSPECCION', 3, '2026-03-04 05:51:24', '127.0.0.1', 'RegistroCheck id 9 inspeccionado por \"Andrés Torres\" el dia \"2026-03-03\".'),
(168, 'registro_checks', 9, 'INSPECCION', 2, '2026-03-04 18:00:48', '127.0.0.1', 'RegistroCheck id 9 inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(169, 'registro_checks', 10, 'CREAR', 2, '2026-03-04 18:01:25', '127.0.0.1', 'Control \"Actualización de Antivirus\" identificado \"2\" fue marcado por \"Raveadmin\" el dia \"2026-03-04\". Observaciones: \"PRUEBA MAXIMO TEXXTO PRUEBA MAXIMO TEXXTO PRUEBA MAXIMO TEXXTO PRUEBA MAXIMO TEXXTO PRUEBA MAXIMO TEXXTO PRUEBA MAXIMO TEXXTO PRUEBA MAXIMO TEXXTO PRUEBA MAXIMO TEXXTO aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\"'),
(170, 'registro_checks', 10, 'INSPECCION', 2, '2026-03-04 18:01:29', '127.0.0.1', 'RegistroCheck id 10 inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(171, 'registro_checks', 10, 'INSPECCION', 2, '2026-03-04 18:03:14', '127.0.0.1', 'RegistroCheck id 10 inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(172, 'registro_checks', 10, 'INSPECCION', 2, '2026-03-04 18:03:24', '127.0.0.1', 'RegistroCheck id 10 inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(173, 'registro_checks', 9, 'INSPECCION', 2, '2026-03-04 18:05:01', '127.0.0.1', 'RegistroCheck id 9 inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(174, 'registro_checks', 10, 'INSPECCION', 2, '2026-03-04 18:05:05', '127.0.0.1', 'RegistroCheck id 10 inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(175, 'registro_checks', 10, 'INSPECCION', 2, '2026-03-04 18:05:15', '127.0.0.1', 'RegistroCheck id 10 inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(176, 'registro_checks', 10, 'INSPECCION', 2, '2026-03-04 18:07:35', '127.0.0.1', 'RegistroCheck id 10 inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(177, 'registro_checks', 10, 'INSPECCION', 2, '2026-03-04 18:09:36', '127.0.0.1', 'RegistroCheck id 10 inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(178, 'registro_checks', 10, 'INSPECCION', 2, '2026-03-04 18:09:43', '127.0.0.1', 'RegistroCheck id 10 inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(179, 'registro_checks', 10, 'INSPECCION', 2, '2026-03-04 18:10:04', '127.0.0.1', 'RegistroCheck id 10 inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(180, 'registro_checks', 10, 'INSPECCION', 2, '2026-03-04 18:10:05', '127.0.0.1', 'RegistroCheck id 10 inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(181, 'registro_checks', 10, 'INSPECCION', 2, '2026-03-04 18:10:05', '127.0.0.1', 'RegistroCheck id 10 inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(182, 'registro_checks', 10, 'INSPECCION', 2, '2026-03-04 18:10:14', '127.0.0.1', 'RegistroCheck id 10 inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(183, 'registro_checks', 6, 'INSPECCION', 2, '2026-03-04 18:10:26', '127.0.0.1', 'RegistroCheck id 6 inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(184, 'registro_checks', 10, 'INSPECCION', 2, '2026-03-04 18:10:31', '127.0.0.1', 'RegistroCheck id 10 inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(185, 'riesgos', 1, 'INSPECCION', 2, '2026-03-04 18:16:21', '127.0.0.1', 'Riesgo \"Falla de Hardware\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(186, 'riesgos', 1, 'EDITAR', 2, '2026-03-04 18:21:03', '127.0.0.1', 'Usuario \"Raveadmin\" editó \"Falla de Hardware\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"riesgos\". Detalle: Riesgo \"Falla de Hardware\" identificado \"1\" fue editado por \"Raveadmin\": Descripción: \"Posible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasd\" -> \"Posible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasd\"; Nivel: \"3\" -> \"3\"'),
(187, 'riesgos', 1, 'INSPECCION', 2, '2026-03-04 18:21:04', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Falla de Hardware\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"riesgos\". Detalle: Riesgo \"Falla de Hardware\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(188, 'riesgos', 1, 'EDITAR', 2, '2026-03-04 18:21:14', '127.0.0.1', 'Usuario \"Raveadmin\" editó \"Falla de Hardware\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"riesgos\". Detalle: Riesgo \"Falla de Hardware\" identificado \"1\" fue editado por \"Raveadmin\": Descripción: \"Posible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasd Posible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasdPosible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasdPosible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasdPosible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasd\" -> \"Posible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasd Posible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasdPosible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasdPosible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasdPosible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasd\"; Nivel: \"3\" -> \"3\"'),
(189, 'riesgos', 1, 'INSPECCION', 2, '2026-03-04 18:21:20', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Falla de Hardware\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"riesgos\". Detalle: Riesgo \"Falla de Hardware\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(190, 'controles', 1, 'INSPECCION', 2, '2026-03-04 18:21:26', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Mantenimiento Preventivo\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"controles\". Detalle: Control \"Mantenimiento Preventivo\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(191, 'riesgos', 1, 'INSPECCION', 2, '2026-03-04 18:21:40', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Falla de Hardware\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"riesgos\". Detalle: Riesgo \"Falla de Hardware\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(192, 'riesgos', 1, 'EDITAR', 2, '2026-03-04 18:21:53', '127.0.0.1', 'Usuario \"Raveadmin\" editó \"Falla de Hardware\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"riesgos\". Detalle: Riesgo \"Falla de Hardware\" identificado \"1\" fue editado por \"Raveadmin\": Descripción: \"Posible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasd Posible daño en componentes físicos del Posible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasdPosible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasdPosible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasdPosible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasdPosible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasdPosible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasdPosible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasdequipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasdPosible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasdPosible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasdPosible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasd\" -> \"Posible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasd Posible daño en componentes físicos del Posible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasdPosible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasdPosible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasdPosible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasdPosible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasdPosible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasdPosible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasdequipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasdPosible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasdPosible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasdPosible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasd\"; Nivel: \"3\" -> \"3\"'),
(193, 'riesgos', 1, 'INSPECCION', 2, '2026-03-04 18:21:56', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Falla de Hardware\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"riesgos\". Detalle: Riesgo \"Falla de Hardware\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(194, 'item_responsable', 2, 'INSPECCION', 2, '2026-03-04 18:24:06', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Equipo de Cómputo - PC Administrativo -> Mariana Ríos\" identificado \"2\" el dia \"2026-03-04\" afectando la tabla \"item_responsable\". Detalle: Asignación del item \"Equipo de Cómputo - PC Administrativo\" al usuario \"Mariana Ríos\" (id 2) fue inspeccionada por \"Raveadmin\" el dia \"2026-03-04\".'),
(195, 'item_responsable', 2, 'INSPECCION', 2, '2026-03-04 18:24:11', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Equipo de Cómputo - PC Administrativo -> Mariana Ríos\" identificado \"2\" el dia \"2026-03-04\" afectando la tabla \"item_responsable\". Detalle: Asignación del item \"Equipo de Cómputo - PC Administrativo\" al usuario \"Mariana Ríos\" (id 2) fue inspeccionada por \"Raveadmin\" el dia \"2026-03-04\".'),
(196, 'controles', 1, 'INSPECCION', 2, '2026-03-04 18:24:13', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Mantenimiento Preventivo\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"controles\". Detalle: Control \"Mantenimiento Preventivo\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(197, 'riesgos', 1, 'INSPECCION', 2, '2026-03-04 18:24:16', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Falla de Hardware\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"riesgos\". Detalle: Riesgo \"Falla de Hardware\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(198, 'items_riesgos', 1, 'INSPECCION', 2, '2026-03-04 18:24:27', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"items_riesgos\". Detalle: Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(199, 'registro_checks', 10, 'INSPECCION', 2, '2026-03-04 18:24:35', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Actualización de Antivirus\" identificado \"10\" el dia \"2026-03-04\" afectando la tabla \"registro_checks\". Detalle: RegistroCheck id 10 inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(200, 'registro_checks', 10, 'INSPECCION', 2, '2026-03-04 18:24:48', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Actualización de Antivirus\" identificado \"10\" el dia \"2026-03-04\" afectando la tabla \"registro_checks\". Detalle: RegistroCheck id 10 inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(201, 'item_responsable', 2, 'INSPECCION', 2, '2026-03-04 18:32:35', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Equipo de Cómputo - PC Administrativo -> Mariana Ríos\" identificado \"2\" el dia \"2026-03-04\" afectando la tabla \"item_responsable\". Detalle: Asignación del item \"Equipo de Cómputo - PC Administrativo\" al usuario \"Mariana Ríos\" (id 2) fue inspeccionada por \"Raveadmin\" el dia \"2026-03-04\".'),
(202, 'controles', 1, 'INSPECCION', 2, '2026-03-04 18:32:38', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Mantenimiento Preventivo\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"controles\". Detalle: Control \"Mantenimiento Preventivo\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(203, 'controles', 1, 'INSPECCION', 2, '2026-03-04 18:32:39', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Mantenimiento Preventivo\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"controles\". Detalle: Control \"Mantenimiento Preventivo\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(204, 'riesgos', 1, 'INSPECCION', 2, '2026-03-04 18:32:43', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Falla de Hardware\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"riesgos\". Detalle: Riesgo \"Falla de Hardware\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(205, 'riesgos', 1, 'INSPECCION', 2, '2026-03-04 18:32:44', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Falla de Hardware\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"riesgos\". Detalle: Riesgo \"Falla de Hardware\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(206, 'items_riesgos', 1, 'INSPECCION', 2, '2026-03-04 18:32:51', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"items_riesgos\". Detalle: Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(207, 'items_riesgos', 1, 'INSPECCION', 2, '2026-03-04 18:32:52', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"items_riesgos\". Detalle: Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(208, 'items_riesgos', 1, 'INSPECCION', 2, '2026-03-04 19:39:21', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"items_riesgos\". Detalle: Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(209, 'items_riesgos', 1, 'EDITAR', 2, '2026-03-04 19:39:33', '127.0.0.1', 'Usuario \"Raveadmin\" editó \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"items_riesgos\". Detalle: Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue editado por \"Raveadmin\": Criticidad: \"3\" -> \"3\"; Estado: \"inactivo\" -> \"inactivo\"');
INSERT INTO `auditoria` (`id_auditoria`, `tabla_afectada`, `id_registro`, `accion`, `id_usuario`, `fecha_hora`, `ip_origen`, `descripcion`) VALUES
(210, 'items_riesgos', 1, 'EDITAR', 2, '2026-03-04 19:39:59', '127.0.0.1', 'Usuario \"Raveadmin\" editó \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"items_riesgos\". Detalle: Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue editado por \"Raveadmin\": Criticidad: \"3\" -> \"3\"; Estado: \"activo\" -> \"activo\"'),
(211, 'item_responsable', 9, 'ASIGNAR', 2, '2026-03-04 19:41:28', '127.0.0.1', 'Usuario \"Raveadmin\" asignó \"CELULAR DE ENDER -> Mariana Ríos\" identificado \"9\" el dia \"2026-03-04\" afectando la tabla \"item_responsable\". Detalle: Asignación creada: item \"CELULAR DE ENDER\" asignado a \"Mariana Ríos\" por \"Raveadmin\".'),
(212, 'registro_checks', 10, 'INSPECCION', 2, '2026-03-04 19:44:06', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Actualización de Antivirus\" identificado \"10\" el dia \"2026-03-04\" afectando la tabla \"registro_checks\". Detalle: RegistroCheck id 10 inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(213, 'items_riesgos', 1, 'INSPECCION', 2, '2026-03-04 19:56:25', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"items_riesgos\". Detalle: Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(214, 'registro_checks', 10, 'INSPECCION', 2, '2026-03-04 19:57:19', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Actualización de Antivirus\" identificado \"10\" el dia \"2026-03-04\" afectando la tabla \"registro_checks\". Detalle: RegistroCheck id 10 inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(215, 'registro_checks', 10, 'INSPECCION', 2, '2026-03-04 20:07:27', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Actualización de Antivirus\" identificado \"10\" el dia \"2026-03-04\" afectando la tabla \"registro_checks\". Detalle: RegistroCheck id 10 inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(216, 'riesgos', 1, 'INSPECCION', 2, '2026-03-04 20:08:05', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Falla de Hardware\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"riesgos\". Detalle: Riesgo \"Falla de Hardware\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(217, 'riesgos', 1, 'INSPECCION', 2, '2026-03-04 20:08:06', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Falla de Hardware\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"riesgos\". Detalle: Riesgo \"Falla de Hardware\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(218, 'riesgos', 1, 'INSPECCION', 2, '2026-03-04 20:08:06', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Falla de Hardware\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"riesgos\". Detalle: Riesgo \"Falla de Hardware\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(219, 'riesgos', 1, 'INSPECCION', 2, '2026-03-04 20:08:07', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Falla de Hardware\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"riesgos\". Detalle: Riesgo \"Falla de Hardware\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(220, 'controles', 3, 'INSPECCION', 2, '2026-03-04 20:08:17', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Revisar Spam de Correo\" identificado \"3\" el dia \"2026-03-04\" afectando la tabla \"controles\". Detalle: Control \"Revisar Spam de Correo\" identificado \"3\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(221, 'registro_checks', 10, 'INSPECCION', 2, '2026-03-04 20:08:36', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Actualización de Antivirus\" identificado \"10\" el dia \"2026-03-04\" afectando la tabla \"registro_checks\". Detalle: RegistroCheck id 10 inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(222, 'item_responsable', 2, 'INSPECCION', 2, '2026-03-04 20:08:56', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Equipo de Cómputo - PC Administrativo -> Mariana Ríos\" identificado \"2\" el dia \"2026-03-04\" afectando la tabla \"item_responsable\". Detalle: Asignación del item \"Equipo de Cómputo - PC Administrativo\" al usuario \"Mariana Ríos\" (id 2) fue inspeccionada por \"Raveadmin\" el dia \"2026-03-04\".'),
(223, 'item_responsable', 2, 'INSPECCION', 2, '2026-03-04 20:08:57', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Equipo de Cómputo - PC Administrativo -> Mariana Ríos\" identificado \"2\" el dia \"2026-03-04\" afectando la tabla \"item_responsable\". Detalle: Asignación del item \"Equipo de Cómputo - PC Administrativo\" al usuario \"Mariana Ríos\" (id 2) fue inspeccionada por \"Raveadmin\" el dia \"2026-03-04\".'),
(224, 'controles', 1, 'INSPECCION', 2, '2026-03-04 20:09:04', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Mantenimiento Preventivo\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"controles\". Detalle: Control \"Mantenimiento Preventivo\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(225, 'riesgos', 1, 'INSPECCION', 2, '2026-03-04 20:09:13', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Falla de Hardware\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"riesgos\". Detalle: Riesgo \"Falla de Hardware\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(226, 'riesgos', 1, 'INSPECCION', 2, '2026-03-04 20:09:14', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Falla de Hardware\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"riesgos\". Detalle: Riesgo \"Falla de Hardware\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(227, 'items_riesgos', 1, 'INSPECCION', 2, '2026-03-04 20:09:27', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"items_riesgos\". Detalle: Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(228, 'items_riesgos', 1, 'INSPECCION', 2, '2026-03-04 20:09:28', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"items_riesgos\". Detalle: Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(229, 'registro_checks', 10, 'INSPECCION', 2, '2026-03-04 20:10:14', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Actualización de Antivirus\" identificado \"10\" el dia \"2026-03-04\" afectando la tabla \"registro_checks\". Detalle: RegistroCheck id 10 inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(230, 'registro_checks', 10, 'INSPECCION', 2, '2026-03-04 20:10:23', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Actualización de Antivirus\" identificado \"10\" el dia \"2026-03-04\" afectando la tabla \"registro_checks\". Detalle: RegistroCheck id 10 inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(231, 'registro_checks', 10, 'INSPECCION', 2, '2026-03-04 20:17:04', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Actualización de Antivirus\" identificado \"10\" el dia \"2026-03-04\" afectando la tabla \"registro_checks\". Detalle: RegistroCheck id 10 inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(232, 'riesgos', 1, 'INSPECCION', 2, '2026-03-04 20:17:14', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Falla de Hardware\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"riesgos\". Detalle: Riesgo \"Falla de Hardware\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(233, 'riesgos', 1, 'INSPECCION', 2, '2026-03-04 20:17:15', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Falla de Hardware\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"riesgos\". Detalle: Riesgo \"Falla de Hardware\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(234, 'items_riesgos', 1, 'INSPECCION', 2, '2026-03-04 20:17:36', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"items_riesgos\". Detalle: Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(235, 'items_riesgos', 1, 'INSPECCION', 2, '2026-03-04 20:17:38', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"items_riesgos\". Detalle: Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(236, 'registro_checks', 10, 'INSPECCION', 2, '2026-03-04 20:20:11', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Actualización de Antivirus\" identificado \"10\" el dia \"2026-03-04\" afectando la tabla \"registro_checks\". Detalle: RegistroCheck id 10 inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(237, 'registro_checks', 10, 'INSPECCION', 2, '2026-03-04 20:21:22', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Actualización de Antivirus\" identificado \"10\" el dia \"2026-03-04\" afectando la tabla \"registro_checks\". Detalle: RegistroCheck id 10 inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(238, 'registro_checks', 10, 'INSPECCION', 2, '2026-03-04 20:21:33', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Actualización de Antivirus\" identificado \"10\" el dia \"2026-03-04\" afectando la tabla \"registro_checks\". Detalle: RegistroCheck id 10 inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(239, 'item_responsable', 2, 'INSPECCION', 2, '2026-03-04 20:21:39', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Equipo de Cómputo - PC Administrativo -> Mariana Ríos\" identificado \"2\" el dia \"2026-03-04\" afectando la tabla \"item_responsable\". Detalle: Asignación del item \"Equipo de Cómputo - PC Administrativo\" al usuario \"Mariana Ríos\" (id 2) fue inspeccionada por \"Raveadmin\" el dia \"2026-03-04\".'),
(240, 'controles', 1, 'INSPECCION', 2, '2026-03-04 20:21:43', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Mantenimiento Preventivo\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"controles\". Detalle: Control \"Mantenimiento Preventivo\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(241, 'riesgos', 1, 'INSPECCION', 2, '2026-03-04 20:21:45', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Falla de Hardware\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"riesgos\". Detalle: Riesgo \"Falla de Hardware\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(242, 'items_riesgos', 1, 'INSPECCION', 2, '2026-03-04 20:21:47', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"items_riesgos\". Detalle: Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(243, 'items_riesgos', 1, 'INSPECCION', 2, '2026-03-04 20:21:51', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"items_riesgos\". Detalle: Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(244, 'items_riesgos', 1, 'INSPECCION', 2, '2026-03-04 20:21:51', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"items_riesgos\". Detalle: Item \"Equipo de Cómputo - PC Administrativo\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(245, 'registro_checks', 10, 'INSPECCION', 2, '2026-03-04 20:24:21', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Actualización de Antivirus\" identificado \"10\" el dia \"2026-03-04\" afectando la tabla \"registro_checks\". Detalle: RegistroCheck id 10 inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(246, 'registro_checks', 10, 'INSPECCION', 2, '2026-03-04 20:30:11', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Actualización de Antivirus\" identificado \"10\" el dia \"2026-03-04\" afectando la tabla \"registro_checks\". Detalle: RegistroCheck id 10 inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(247, 'riesgos', 1, 'INSPECCION', 2, '2026-03-04 20:30:45', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Falla de Hardware\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"riesgos\". Detalle: Riesgo \"Falla de Hardware\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(248, 'riesgos', 1, 'INSPECCION', 2, '2026-03-04 20:30:46', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Falla de Hardware\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"riesgos\". Detalle: Riesgo \"Falla de Hardware\" identificado \"1\" fue inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(249, 'registro_checks', 10, 'INSPECCION', 2, '2026-03-04 20:31:10', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Actualización de Antivirus\" identificado \"10\" el dia \"2026-03-04\" afectando la tabla \"registro_checks\". Detalle: RegistroCheck id 10 inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(250, 'registro_checks', 11, 'CREAR', 2, '2026-03-04 20:31:28', '127.0.0.1', 'Usuario \"Raveadmin\" creó \"Mantenimiento Preventivo\" identificado \"11\" el dia \"2026-03-04\" afectando la tabla \"registro_checks\". Detalle: Control \"Mantenimiento Preventivo\" identificado \"1\" fue marcado por \"Raveadmin\" el dia \"2026-03-04\".'),
(251, 'registro_checks', 11, 'INSPECCION', 2, '2026-03-04 20:31:34', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Mantenimiento Preventivo\" identificado \"11\" el dia \"2026-03-04\" afectando la tabla \"registro_checks\". Detalle: RegistroCheck id 11 inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(252, 'item_responsable', 2, 'INSPECCION', 2, '2026-03-04 20:39:44', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Equipo de Cómputo - PC Administrativo -> Mariana Ríos\" identificado \"2\" el dia \"2026-03-04\" afectando la tabla \"item_responsable\". Detalle: Asignación del item \"Equipo de Cómputo - PC Administrativo\" al usuario \"Mariana Ríos\" (id 2) fue inspeccionada por \"Raveadmin\" el dia \"2026-03-04\".'),
(253, 'controles', 5, 'CREAR', 5, '2026-03-05 00:13:57', '127.0.0.1', 'Usuario \"Super Prueba\" creó \"Automated Test Control\" identificado \"5\" el dia \"2026-03-04\" afectando la tabla \"controles\". Detalle: Control \"Automated Test Control\" identificado \"5\" fue creado por \"Super Prueba\". Riesgo: \"Falla de Hardware\". Frecuencia: \"DIARIO\". Estado: \"Activo\".'),
(254, 'controles', 6, 'CREAR', 5, '2026-03-05 00:15:07', '127.0.0.1', 'Usuario \"Super Prueba\" creó \"Automated Test Control\" identificado \"6\" el dia \"2026-03-04\" afectando la tabla \"controles\". Detalle: Control \"Automated Test Control\" identificado \"6\" fue creado por \"Super Prueba\". Riesgo: \"Falla de Hardware\". Frecuencia: \"DIARIO\". Estado: \"Activo\".'),
(255, 'controles', 6, 'EDITAR', 5, '2026-03-05 00:15:07', '127.0.0.1', 'Usuario \"Super Prueba\" editó \"Automated Test Control (edited)\" identificado \"6\" el dia \"2026-03-04\" afectando la tabla \"controles\". Detalle: Control \"Automated Test Control (edited)\" identificado \"6\" fue editado por \"Super Prueba\": Nombre: \"Automated Test Control (edited)\" -> \"Automated Test Control (edited)\"; Descripción: \"Editado por script\" -> \"Editado por script\"'),
(256, 'controles', 7, 'CREAR', 5, '2026-03-05 00:31:51', '127.0.0.1', 'Usuario \"Super Prueba\" creó \"Automated Test Control\" identificado \"7\" el dia \"2026-03-04\" afectando la tabla \"controles\". Detalle: Control \"Automated Test Control\" identificado \"7\" fue creado por \"Super Prueba\". Riesgo: \"Falla de Hardware\". Frecuencia: \"DIARIO\". Estado: \"Activo\".'),
(257, 'controles', 7, 'EDITAR', 5, '2026-03-05 00:31:51', '127.0.0.1', 'Usuario \"Super Prueba\" editó \"Automated Test Control (edited)\" identificado \"7\" el dia \"2026-03-04\" afectando la tabla \"controles\". Detalle: Control \"Automated Test Control (edited)\" identificado \"7\" fue editado por \"Super Prueba\": Nombre: \"Automated Test Control (edited)\" -> \"Automated Test Control (edited)\"; Descripción: \"Editado por script\" -> \"Editado por script\"'),
(258, 'controles', 7, 'ELIMINAR', 5, '2026-03-05 00:31:51', '127.0.0.1', 'Usuario \"Super Prueba\" eliminó \"7\" identificado \"7\" el dia \"2026-03-04\" afectando la tabla \"controles\". Detalle: Control \"Automated Test Control (edited)\" identificado \"7\" fue eliminado por \"Super Prueba\".'),
(259, 'item_responsable', 4, 'EDITAR', 5, '2026-03-05 00:32:44', '127.0.0.1', 'Usuario \"Super Prueba\" editó \"Equipo de Cómputo - PC Administrativo -> Raveadmin\" identificado \"4\" el dia \"2026-03-04\" afectando la tabla \"item_responsable\". Detalle: Asignación id 4 (item \"Equipo de Cómputo - PC Administrativo\" a \"Raveadmin\") fue editada por \"Super Prueba\".'),
(260, 'item_responsable', 4, 'ELIMINAR', 5, '2026-03-05 00:32:44', '127.0.0.1', 'Usuario \"Super Prueba\" eliminó \"4\" identificado \"4\" el dia \"2026-03-04\" afectando la tabla \"item_responsable\". Detalle: Asignación id 4 (item \"Equipo de Cómputo - PC Administrativo\" a \"Raveadmin\") fue eliminada por \"Super Prueba\".'),
(261, 'item_responsable', 2, 'EDITAR', 1, '2026-03-05 00:34:21', '127.0.0.1', 'Usuario \"Jose Rave\" editó \"Equipo de Cómputo - PC Administrativo -> Mariana Ríos\" identificado \"2\" el dia \"2026-03-04\" afectando la tabla \"item_responsable\". Detalle: Asignación id 2 (item \"Equipo de Cómputo - PC Administrativo\" a \"Mariana Ríos\") fue editada por \"Jose Rave\".'),
(262, 'item_responsable', 2, 'EDITAR', 1, '2026-03-05 00:34:33', '127.0.0.1', 'Usuario \"Jose Rave\" editó \"Equipo de Cómputo - PC Administrativo -> Mariana Ríos\" identificado \"2\" el dia \"2026-03-04\" afectando la tabla \"item_responsable\". Detalle: Asignación id 2 (item \"Equipo de Cómputo - PC Administrativo\" a \"Mariana Ríos\") fue editada por \"Jose Rave\".'),
(263, 'riesgos', 1, 'EDITAR', 1, '2026-03-05 00:43:02', '127.0.0.1', 'Usuario \"Jose Rave\" editó \"Falla de Hardware\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"riesgos\". Detalle: Riesgo \"Falla de Hardware\" identificado \"1\" fue editado por \"Jose Rave\": Nivel: \"3\" -> \"3\"; Estado: \"inactivo\" -> \"inactivo\"'),
(264, 'registro_checks', 1, 'INSPECCION', 1, '2026-03-05 00:56:16', '127.0.0.1', 'Usuario \"Jose Rave\" inspeccionó \"Mantenimiento Preventivo\" identificado \"1\" el dia \"2026-03-04\" afectando la tabla \"registro_checks\". Detalle: RegistroCheck id 1 inspeccionado por \"Jose Rave\" el dia \"2026-03-04\".'),
(265, 'registro_checks', 6, 'INSPECCION', 1, '2026-03-05 00:56:20', '127.0.0.1', 'Usuario \"Jose Rave\" inspeccionó \"Mantenimiento Preventivo\" identificado \"6\" el dia \"2026-03-04\" afectando la tabla \"registro_checks\". Detalle: RegistroCheck id 6 inspeccionado por \"Jose Rave\" el dia \"2026-03-04\".'),
(266, 'registro_checks', 7, 'INSPECCION', 1, '2026-03-05 00:56:22', '127.0.0.1', 'Usuario \"Jose Rave\" inspeccionó \"Mantenimiento Preventivo\" identificado \"7\" el dia \"2026-03-04\" afectando la tabla \"registro_checks\". Detalle: RegistroCheck id 7 inspeccionado por \"Jose Rave\" el dia \"2026-03-04\".'),
(267, 'item_responsable', 9, 'EDITAR', 1, '2026-03-05 00:56:53', '127.0.0.1', 'Usuario \"Jose Rave\" editó \"CELULAR DE ENDER -> Jose Rave\" identificado \"9\" el dia \"2026-03-04\" afectando la tabla \"item_responsable\". Detalle: Asignación id 9 (item \"CELULAR DE ENDER\" a \"Jose Rave\") fue editada por \"Jose Rave\".'),
(268, 'registro_checks', 12, 'CREAR', 1, '2026-03-05 00:57:04', '127.0.0.1', 'Usuario \"Jose Rave\" creó \"Refrigeración al Celular\" identificado \"12\" el dia \"2026-03-04\" afectando la tabla \"registro_checks\". Detalle: Control \"Refrigeración al Celular\" identificado \"4\" fue marcado por \"Jose Rave\" el dia \"2026-03-04\".'),
(269, 'registro_checks', 12, 'INSPECCION', 1, '2026-03-05 00:57:20', '127.0.0.1', 'Usuario \"Jose Rave\" inspeccionó \"Refrigeración al Celular\" identificado \"12\" el dia \"2026-03-04\" afectando la tabla \"registro_checks\". Detalle: RegistroCheck id 12 inspeccionado por \"Jose Rave\" el dia \"2026-03-04\".'),
(270, 'item_responsable', 10, 'ASIGNAR', 1, '2026-03-05 00:58:57', '127.0.0.1', 'Usuario \"Jose Rave\" asignó \"Prueba -> Mariana Ríos\" identificado \"10\" el dia \"2026-03-04\" afectando la tabla \"item_responsable\". Detalle: Asignación creada: item \"Prueba\" asignado a \"Mariana Ríos\" por \"Jose Rave\".'),
(271, 'registro_checks', 12, 'INSPECCION', 1, '2026-03-05 01:01:29', '127.0.0.1', 'Usuario \"Jose Rave\" inspeccionó \"Refrigeración al Celular\" identificado \"12\" el dia \"2026-03-04\" afectando la tabla \"registro_checks\". Detalle: RegistroCheck id 12 inspeccionado por \"Jose Rave\" el dia \"2026-03-04\".'),
(272, 'item_responsable', 2, 'EDITAR', 1, '2026-03-05 01:02:57', '127.0.0.1', 'Usuario \"Jose Rave\" editó \"Equipo de Cómputo - PC Administrativo -> Mariana Ríos\" identificado \"2\" el dia \"2026-03-04\" afectando la tabla \"item_responsable\". Detalle: Asignación id 2 (item \"Equipo de Cómputo - PC Administrativo\" a \"Mariana Ríos\") fue editada por \"Jose Rave\".'),
(273, 'registro_checks', 10, 'INSPECCION', 1, '2026-03-05 01:06:05', '127.0.0.1', 'Usuario \"Jose Rave\" inspeccionó \"Actualización de Antivirus\" identificado \"10\" el dia \"2026-03-04\" afectando la tabla \"registro_checks\". Detalle: RegistroCheck id 10 inspeccionado por \"Jose Rave\" el dia \"2026-03-04\".'),
(274, 'controles', 3, 'EDITAR', 1, '2026-03-05 01:16:25', '127.0.0.1', 'Usuario \"Jose Rave\" editó \"Revisar Spam de Correo\" identificado \"3\" el dia \"2026-03-04\" afectando la tabla \"controles\". Detalle: Control \"Revisar Spam de Correo\" identificado \"3\" fue editado por \"Jose Rave\": Estado: \"inactivo\" -> \"inactivo\"'),
(275, 'usuarios', 1, 'INSPECCION', 1, '2026-03-05 01:32:11', '127.0.0.1', 'Usuario \"Jose Rave\" id 1 inspeccionado por \"Jose Rave\" el dia \"2026-03-04\".'),
(276, 'usuarios', 4, 'INSPECCION', 1, '2026-03-05 01:32:20', '127.0.0.1', 'Usuario \"Mariana Ríos\" id 4 inspeccionado por \"Jose Rave\" el dia \"2026-03-04\".'),
(277, 'usuarios', 4, 'EDITAR', 1, '2026-03-05 01:32:30', '127.0.0.1', 'Usuario \"Mariana Ríos\" id 4 editado por \"Jose Rave\".'),
(278, 'usuarios', 4, 'EDITAR', 1, '2026-03-05 01:32:34', '127.0.0.1', 'Usuario \"Mariana Ríos\" id 4 editado por \"Jose Rave\".'),
(279, 'usuarios', 4, 'EDITAR', 1, '2026-03-05 01:32:39', '127.0.0.1', 'Usuario \"Mariana Ríos\" id 4 editado por \"Jose Rave\".'),
(280, 'usuarios', 4, 'EDITAR', 1, '2026-03-05 01:33:05', '127.0.0.1', 'Usuario \"Mariana Ríos\" id 4 editado por \"Jose Rave\".'),
(281, 'usuarios', 1, 'INSPECCION', 1, '2026-03-05 01:33:58', '127.0.0.1', 'Usuario \"Jose Rave\" id 1 inspeccionado por \"Jose Rave\" el dia \"2026-03-04\".'),
(282, 'usuarios', 5, 'EDITAR', 1, '2026-03-05 01:54:46', '127.0.0.1', 'Usuario \"Super Prueba\" id 5 editado por \"Jose Rave\".'),
(283, 'usuarios', 1, 'INSPECCION', 1, '2026-03-05 02:02:49', '127.0.0.1', 'Usuario \"Jose Rave\" id 1 inspeccionado por \"Jose Rave\" el dia \"2026-03-04\".'),
(284, 'usuarios', 2, 'EDITAR', 1, '2026-03-05 02:03:31', '127.0.0.1', 'Contraseña del usuario \"Raveadmin\" (id 2) reestablecida por \"Jose Rave\".'),
(285, 'usuarios', 2, 'INSPECCION', 1, '2026-03-05 02:03:31', '127.0.0.1', 'Usuario \"Raveadmin\" id 2 inspeccionado por \"Jose Rave\" el dia \"2026-03-04\".'),
(286, 'usuarios', 1, 'INSPECCION', 1, '2026-03-05 02:03:43', '127.0.0.1', 'Usuario \"Jose Rave\" id 1 inspeccionado por \"Jose Rave\" el dia \"2026-03-04\".'),
(287, 'usuarios', 1, 'INSPECCION', 1, '2026-03-05 02:05:05', '127.0.0.1', 'Usuario \"Jose Rave\" id 1 inspeccionado por \"Jose Rave\" el dia \"2026-03-04\".'),
(288, 'usuarios', 1, 'INSPECCION', 1, '2026-03-05 02:13:20', '127.0.0.1', 'Usuario \"Jose Rave\" id 1 inspeccionado por \"Jose Rave\" el dia \"2026-03-04\".'),
(289, 'usuarios', 1, 'INSPECCION', 1, '2026-03-05 02:24:09', '127.0.0.1', 'Usuario \"Jose Rave\" id 1 inspeccionado por \"Jose Rave\" el dia \"2026-03-04\".'),
(290, 'registro_checks', 12, 'INSPECCION', 1, '2026-03-05 02:24:19', '127.0.0.1', 'Usuario \"Jose Rave\" inspeccionó \"Refrigeración al Celular\" identificado \"12\" el dia \"2026-03-04\" afectando la tabla \"registro_checks\". Detalle: RegistroCheck id 12 inspeccionado por \"Jose Rave\" el dia \"2026-03-04\".'),
(291, 'registro_checks', 12, 'INSPECCION', 1, '2026-03-05 02:24:34', '127.0.0.1', 'Usuario \"Jose Rave\" inspeccionó \"Refrigeración al Celular\" identificado \"12\" el dia \"2026-03-04\" afectando la tabla \"registro_checks\". Detalle: RegistroCheck id 12 inspeccionado por \"Jose Rave\" el dia \"2026-03-04\".'),
(292, 'registro_checks', 12, 'INSPECCION', 1, '2026-03-05 02:24:37', '127.0.0.1', 'Usuario \"Jose Rave\" inspeccionó \"Refrigeración al Celular\" identificado \"12\" el dia \"2026-03-04\" afectando la tabla \"registro_checks\". Detalle: RegistroCheck id 12 inspeccionado por \"Jose Rave\" el dia \"2026-03-04\".'),
(293, 'usuarios', 1, 'INSPECCION', 1, '2026-03-05 02:30:57', '127.0.0.1', 'Usuario \"Jose Rave\" id 1 inspeccionado por \"Jose Rave\" el dia \"2026-03-04\".'),
(294, 'usuarios', 1, 'INSPECCION', 1, '2026-03-05 02:31:24', '127.0.0.1', 'Usuario \"Jose Rave\" id 1 inspeccionado por \"Jose Rave\" el dia \"2026-03-04\".'),
(295, 'usuarios', 1, 'INSPECCION', 1, '2026-03-05 02:33:09', '127.0.0.1', 'Usuario \"Jose Rave\" id 1 inspeccionado por \"Jose Rave\" el dia \"2026-03-04\".'),
(296, 'usuarios', 1, 'INSPECCION', 1, '2026-03-05 02:33:24', '127.0.0.1', 'Usuario \"Jose Rave\" id 1 inspeccionado por \"Jose Rave\" el dia \"2026-03-04\".'),
(297, 'usuarios', 1, 'INSPECCION', 1, '2026-03-05 02:33:33', '127.0.0.1', 'Usuario \"Jose Rave\" id 1 inspeccionado por \"Jose Rave\" el dia \"2026-03-04\".'),
(298, 'usuarios', 1, 'INSPECCION', 1, '2026-03-05 02:36:00', '127.0.0.1', 'Usuario \"Jose Rave\" id 1 inspeccionado por \"Jose Rave\" el dia \"2026-03-04\".'),
(299, 'usuarios', 1, 'INSPECCION', 1, '2026-03-05 02:36:06', '127.0.0.1', 'Usuario \"Jose Rave\" id 1 inspeccionado por \"Jose Rave\" el dia \"2026-03-04\".'),
(300, 'usuarios', 1, 'INSPECCION', 1, '2026-03-05 02:36:21', '127.0.0.1', 'Usuario \"Jose Rave\" id 1 inspeccionado por \"Jose Rave\" el dia \"2026-03-04\".'),
(301, 'registro_checks', 12, 'INSPECCION', 1, '2026-03-05 02:36:53', '127.0.0.1', 'Usuario \"Jose Rave\" inspeccionó \"Refrigeración al Celular\" identificado \"12\" el dia \"2026-03-04\" afectando la tabla \"registro_checks\". Detalle: RegistroCheck id 12 inspeccionado por \"Jose Rave\" el dia \"2026-03-04\".'),
(302, 'usuarios', 1, 'INSPECCION', 1, '2026-03-05 02:37:20', '127.0.0.1', 'Usuario \"Jose Rave\" id 1 inspeccionado por \"Jose Rave\" el dia \"2026-03-04\".'),
(303, 'usuarios', 1, 'INSPECCION', 1, '2026-03-05 02:37:37', '127.0.0.1', 'Usuario \"Jose Rave\" id 1 inspeccionado por \"Jose Rave\" el dia \"2026-03-04\".'),
(304, 'usuarios', 1, 'INSPECCION', 1, '2026-03-05 02:38:07', '127.0.0.1', 'Usuario \"Jose Rave\" id 1 inspeccionado por \"Jose Rave\" el dia \"2026-03-04\".'),
(305, 'usuarios', 2, 'EDITAR', 1, '2026-03-05 02:51:46', '127.0.0.1', 'Usuario \"Raveadmin\" id 2 editado por \"Jose Rave\".'),
(306, 'usuarios', 2, 'EDITAR', 1, '2026-03-05 02:53:52', '127.0.0.1', 'Contraseña del usuario \"Raveadmin\" (id 2) reestablecida por \"Jose Rave\".'),
(307, 'usuarios', 2, 'INSPECCION', 1, '2026-03-05 02:53:52', '127.0.0.1', 'Usuario \"Raveadmin\" id 2 inspeccionado por \"Jose Rave\" el dia \"2026-03-04\".'),
(308, 'usuarios', 1, 'EDITAR', 1, '2026-03-05 02:54:31', '127.0.0.1', 'Usuario \"Jose Rave\" id 1 editado por \"Jose Rave\".'),
(309, 'usuarios', 1, 'EDITAR', 2, '2026-03-05 02:55:18', '127.0.0.1', 'Usuario \"Jose Rave\" id 1 editado por \"Raveadmin\".'),
(310, 'usuarios', 3, 'EDITAR', 1, '2026-03-05 02:57:38', '127.0.0.1', 'Usuario \"Andrés Torres\" id 3 editado por \"Jose Rave\".'),
(311, 'usuarios', 6, 'CREAR', 2, '2026-03-05 03:23:11', '127.0.0.1', 'Usuario \"El Señor Responsable\" creado por \"Raveadmin\".'),
(312, 'usuarios', 7, 'CREAR', 2, '2026-03-05 03:25:50', '127.0.0.1', 'Usuario \"El Señor Responsable\" creado por \"Raveadmin\".'),
(313, 'item_responsable', 11, 'ASIGNAR', 2, '2026-03-05 03:29:00', '127.0.0.1', 'Usuario \"Raveadmin\" asignó \"CELULAR DE ENDER -> El Señor Responsable\" identificado \"11\" el dia \"2026-03-04\" afectando la tabla \"item_responsable\". Detalle: Asignación creada: item \"CELULAR DE ENDER\" asignado a \"El Señor Responsable\" por \"Raveadmin\".'),
(314, 'registro_checks', 13, 'CREAR', 7, '2026-03-05 03:29:36', '127.0.0.1', 'Usuario \"El Señor Responsable\" creó \"Refrigeración al Celular\" identificado \"13\" el dia \"2026-03-04\" afectando la tabla \"registro_checks\". Detalle: Control \"Refrigeración al Celular\" identificado \"4\" fue marcado por \"El Señor Responsable\" el dia \"2026-03-04\".'),
(315, 'registro_checks', 13, 'INSPECCION', 2, '2026-03-05 03:29:49', '127.0.0.1', 'Usuario \"Raveadmin\" inspeccionó \"Refrigeración al Celular\" identificado \"13\" el dia \"2026-03-04\" afectando la tabla \"registro_checks\". Detalle: RegistroCheck id 13 inspeccionado por \"Raveadmin\" el dia \"2026-03-04\".'),
(316, 'item_responsable', 11, 'EDITAR', 2, '2026-03-05 03:30:03', '127.0.0.1', 'Usuario \"Raveadmin\" editó \"CELULAR DE ENDER -> El Señor Responsable\" identificado \"11\" el dia \"2026-03-04\" afectando la tabla \"item_responsable\". Detalle: Asignación id 11 (item \"CELULAR DE ENDER\" a \"El Señor Responsable\") fue editada por \"Raveadmin\".'),
(317, 'item_responsable', 11, 'EDITAR', 2, '2026-03-05 03:30:50', '127.0.0.1', 'Usuario \"Raveadmin\" editó \"CELULAR DE ENDER -> El Señor Responsable\" identificado \"11\" el dia \"2026-03-04\" afectando la tabla \"item_responsable\". Detalle: Asignación id 11 (item \"CELULAR DE ENDER\" a \"El Señor Responsable\") fue editada por \"Raveadmin\".'),
(318, 'riesgos', 1, 'EDITAR', 2, '2026-03-05 17:33:38', '127.0.0.1', 'Usuario \"Raveadmin\" editó \"Falla de Hardware\" identificado \"1\" el dia \"2026-03-05\" afectando la tabla \"riesgos\". Detalle: El usuario Raveadmin editó la amenaza FALLA DE HARDWARE con id 1 el día 2026-03-05 afectando la tabla riesgos cambiando NIVEL que contenía 3 ahora siendo NIVEL que contiene 3; ESTADO que contenía ACTIVO ahora siendo ESTADO que contiene ACTIVO.'),
(319, 'usuarios', 1, 'EDITAR', 2, '2026-03-05 17:41:05', '127.0.0.1', 'Usuario \"Jose Rave\" id 1 editado por \"Raveadmin\".'),
(320, 'item_responsable', 2, 'EDITAR', 2, '2026-03-05 17:41:38', '127.0.0.1', 'Usuario \"Raveadmin\" editó \"Equipo de Cómputo - PC Administrativo -> Mariana Ríos\" identificado \"2\" el dia \"2026-03-05\" afectando la tabla \"item_responsable\". Detalle: El usuario Raveadmin editó la asignación del item EQUIPO DE CÓMPUTO - PC ADMINISTRATIVO asignado a MARIANA RÍOS con id 2 el día 2026-03-05 afectando la tabla item_responsable cambiando ITEM de EQUIPO DE CÓMPUTO - PC ADMINISTRATIVO a EQUIPO DE CÓMPUTO - PC ADMINISTRATIVO y RESPONSABLE de MARIANA RÍOS a MARIANA RÍOS.'),
(321, 'item_responsable', 10, 'ELIMINAR', 2, '2026-03-05 17:41:49', '127.0.0.1', 'Usuario \"Raveadmin\" eliminó \"10\" identificado \"10\" el dia \"2026-03-05\" afectando la tabla \"item_responsable\". Detalle: El usuario Raveadmin eliminó la asignación del item PRUEBA asignado a MARIANA RÍOS con id 10 el día 2026-03-05 afectando la tabla item_responsable.'),
(322, 'controles', 5, 'ELIMINAR', 2, '2026-03-05 17:42:00', '127.0.0.1', 'Usuario \"Raveadmin\" eliminó \"5\" identificado \"5\" el dia \"2026-03-05\" afectando la tabla \"controles\". Detalle: El usuario Raveadmin eliminó el control AUTOMATED TEST CONTROL identificado 5 el día 2026-03-05.'),
(323, 'items_riesgos', 3, 'EDITAR', 2, '2026-03-05 17:42:24', '127.0.0.1', 'Usuario \"Raveadmin\" editó \"Prueba\" identificado \"3\" el dia \"2026-03-05\" afectando la tabla \"items_riesgos\". Detalle: El usuario Raveadmin editó el item PRUEBA con id 3 el día 2026-03-05 afectando la tabla items_riesgos cambiando CRITICIDAD que contenía 2 ahora siendo CRITICIDAD que contiene 2.'),
(324, 'usuarios', 7, 'EDITAR', 2, '2026-03-05 17:50:31', '127.0.0.1', 'Usuario \"El Señor Responsable\" id 7 editado por \"Raveadmin\".'),
(325, 'usuarios', 7, 'EDITAR', 2, '2026-03-05 17:55:08', '127.0.0.1', 'Contraseña del usuario \"El Señor Responsable\" (id 7) reestablecida por \"Raveadmin\".'),
(326, 'usuarios', 7, 'EDITAR', 2, '2026-03-05 17:57:04', '127.0.0.1', 'Usuario \"El Señor Responsable\" id 7 editado por \"Raveadmin\".'),
(327, 'usuarios', 7, 'EDITAR', 2, '2026-03-05 18:28:05', '127.0.0.1', 'Usuario \"El Señor Responsable\" id 7 editado por \"Raveadmin\".'),
(328, 'usuarios', 7, 'EDITAR', 1, '2026-03-05 18:28:39', '127.0.0.1', 'Usuario \"El Señor Responsable\" id 7 editado por \"Jose Rave\".'),
(329, 'registro_checks', 14, 'CREAR', 7, '2026-03-05 18:31:17', '127.0.0.1', 'Usuario \"El Señor Responsable\" creó \"Refrigeración al Celular\" identificado \"14\" el dia \"2026-03-05\" afectando la tabla \"registro_checks\". Detalle: Control \"Refrigeración al Celular\" identificado \"4\" fue marcado por \"El Señor Responsable\" el dia \"2026-03-05\".');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auth_group`
--

CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auth_group_permissions`
--

CREATE TABLE `auth_group_permissions` (
  `id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auth_permission`
--

CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Volcado de datos para la tabla `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add log entry', 1, 'add_logentry'),
(2, 'Can change log entry', 1, 'change_logentry'),
(3, 'Can delete log entry', 1, 'delete_logentry'),
(4, 'Can view log entry', 1, 'view_logentry'),
(5, 'Can add permission', 2, 'add_permission'),
(6, 'Can change permission', 2, 'change_permission'),
(7, 'Can delete permission', 2, 'delete_permission'),
(8, 'Can view permission', 2, 'view_permission'),
(9, 'Can add group', 3, 'add_group'),
(10, 'Can change group', 3, 'change_group'),
(11, 'Can delete group', 3, 'delete_group'),
(12, 'Can view group', 3, 'view_group'),
(13, 'Can add user', 4, 'add_user'),
(14, 'Can change user', 4, 'change_user'),
(15, 'Can delete user', 4, 'delete_user'),
(16, 'Can view user', 4, 'view_user'),
(17, 'Can add content type', 5, 'add_contenttype'),
(18, 'Can change content type', 5, 'change_contenttype'),
(19, 'Can delete content type', 5, 'delete_contenttype'),
(20, 'Can view content type', 5, 'view_contenttype'),
(21, 'Can add session', 6, 'add_session'),
(22, 'Can change session', 6, 'change_session'),
(23, 'Can delete session', 6, 'delete_session'),
(24, 'Can view session', 6, 'view_session');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auth_user`
--

CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Volcado de datos para la tabla `auth_user`
--

INSERT INTO `auth_user` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `date_joined`) VALUES
(1, 'pbkdf2_sha256$1000000$KQE9MAMY8peFIILMg0cYsS$IFC+dE9v953yvdsbbc684cL26LbQp+kf0HiMQl3gTgs=', '2026-02-27 16:38:03.647045', 1, 'Ender', '', '', 'xxlanderlender@gmail.com', 1, 1, '2026-02-27 16:14:31.053396');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auth_user_groups`
--

CREATE TABLE `auth_user_groups` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auth_user_user_permissions`
--

CREATE TABLE `auth_user_user_permissions` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `controles`
--

CREATE TABLE `controles` (
  `id_control` int(11) NOT NULL,
  `id_riesgo` int(11) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `frecuencia` enum('DIARIO') DEFAULT 'DIARIO',
  `estado` enum('activo','inactivo') DEFAULT 'activo',
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp(),
  `creado_por` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Volcado de datos para la tabla `controles`
--

INSERT INTO `controles` (`id_control`, `id_riesgo`, `nombre`, `descripcion`, `frecuencia`, `estado`, `fecha_creacion`, `creado_por`) VALUES
(1, 1, 'Mantenimiento Preventivo', 'Revisión técnica periódica del equip.', 'DIARIO', 'activo', '2026-02-27 16:11:43', 2),
(2, 2, 'Actualización de Antivirus', 'Verificación y actualización diaria del antivirus.', 'DIARIO', 'activo', '2026-02-27 16:11:43', 2),
(3, 2, 'Revisar Spam de Correo', 'Revisar el correo de spam como administrador del panel', 'DIARIO', 'inactivo', '2026-03-04 00:49:10', 3),
(4, 4, 'Refrigeración al Celular', 'Esto es para registrar el celular', 'DIARIO', 'activo', '2026-03-04 05:06:55', 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `django_admin_log`
--

CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) UNSIGNED NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `django_content_type`
--

CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Volcado de datos para la tabla `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(1, 'admin', 'logentry'),
(3, 'auth', 'group'),
(2, 'auth', 'permission'),
(4, 'auth', 'user'),
(5, 'contenttypes', 'contenttype'),
(6, 'sessions', 'session');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `django_migrations`
--

CREATE TABLE `django_migrations` (
  `id` int(11) NOT NULL,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Volcado de datos para la tabla `django_migrations`
--

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1, 'contenttypes', '0001_initial', '2026-02-27 16:12:47.807720'),
(2, 'auth', '0001_initial', '2026-02-27 16:12:48.725313'),
(3, 'admin', '0001_initial', '2026-02-27 16:12:48.932081'),
(4, 'admin', '0002_logentry_remove_auto_add', '2026-02-27 16:12:48.942874'),
(5, 'admin', '0003_logentry_add_action_flag_choices', '2026-02-27 16:12:48.989776'),
(6, 'contenttypes', '0002_remove_content_type_name', '2026-02-27 16:12:49.130850'),
(7, 'auth', '0002_alter_permission_name_max_length', '2026-02-27 16:12:49.206926'),
(8, 'auth', '0003_alter_user_email_max_length', '2026-02-27 16:12:49.276598'),
(9, 'auth', '0004_alter_user_username_opts', '2026-02-27 16:12:49.321695'),
(10, 'auth', '0005_alter_user_last_login_null', '2026-02-27 16:12:49.432777'),
(11, 'auth', '0006_require_contenttypes_0002', '2026-02-27 16:12:49.436990'),
(12, 'auth', '0007_alter_validators_add_error_messages', '2026-02-27 16:12:49.447091'),
(13, 'auth', '0008_alter_user_username_max_length', '2026-02-27 16:12:49.504663'),
(14, 'auth', '0009_alter_user_last_name_max_length', '2026-02-27 16:12:49.560326'),
(15, 'auth', '0010_alter_group_name_max_length', '2026-02-27 16:12:49.616552'),
(16, 'auth', '0011_update_proxy_permissions', '2026-02-27 16:12:49.622392'),
(17, 'auth', '0012_alter_user_first_name_max_length', '2026-02-27 16:12:49.683801'),
(18, 'sessions', '0001_initial', '2026-02-27 16:12:49.770241'),
(19, 'core', '0001_initial', '2026-02-27 21:45:04.922620');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `django_session`
--

CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Volcado de datos para la tabla `django_session`
--

INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
('0rbcymnwq1bg83y9hys7l4u012v9wjsy', '.eJyrViotTi2Kz0xRsjLVgbDz8nOTilKVrJSCSwtSixQCikpTkxKVoJJF-TlKVoa1ABcCEvo:1vxrgZ:ELGOYLHVCsEC8M-BT7ZoRYW5RUGv7SxOP_uhZJ5zkhw', '2026-03-18 19:15:07.815750'),
('1ywc2jmhhjfgj5lo3kgkcawpgpzad6ho', '.eJyrViotTi2Kz0xRsjLVgbDz8nOTilKVrJSCSwtSixQCikpTkxKVoJJF-TlKVoa1ABcCEvo:1vxpVT:e4V_Bq2pCD_grCMAnVg8z8IONMnGKBp_pCgRZxtqoPk', '2026-03-18 16:55:31.960132'),
('31m4j6fbzpzexronr9pmrdv5lelj545i', '.eJyrViotTi2Kz0xRsjLVgbDz8nOTilKVrJSCSwtSixQCikpTkxKVoJJF-TlKVoa1ABcCEvo:1vxruS:hXa7VJKZqPrKdfhBuffeioV7gGAuCbYSGXUnl9UpnuU', '2026-03-18 19:29:28.865753'),
('4abijgojyn7wrpmprr0k0uzau53drlfj', '.eJyrViotTi2Kz0xRsjLVgbDz8nOTilKVrJSCSwtSixQCikpTkxKVoJJF-TlKVoa1ABcCEvo:1vxrbx:s6k4Q95qFgVVjNAS7zM-i-LC_JkJlcsztEMV2CNfg8w', '2026-03-18 19:10:21.356528'),
('4zw7bapq242njwi5lv8u9d5t98qmkpxz', '.eJyrViotTi2Kz0xRsjLVgbDz8nOTilKVrJSCSwtSixQCikpTkxKVoJJF-TlKVoa1ABcCEvo:1vxpV2:_5bGHxG_5xwGNcdJMn4rDN6gHWWGxl4HLhkbLHpHLlI', '2026-03-18 16:55:04.153071'),
('5rixciqubfj0x1rfxevfs8c76ctfmkvh', '.eJyrViotTi2Kz0xRsjLUgbDz8nOTilKVrJS88otTFYISy1KVoDJF-TlAZbUA2IARpw:1vxsrs:_r3MJUTnMGCtLgVrBuxX7wP1yGD6EwsZpES5CJ72two', '2026-03-18 20:30:52.894245'),
('6ivgujnbpx55bnvav2q09inihlza5buz', '.eJyrViotTi2Kz0xRsjLVgbDz8nOTilKVrJSCSwtSixQCikpTkxKVoJJF-TlKVoa1ABcCEvo:1vxsYd:9x5YA7Zl833hcG9wc_nJIQcYze51tu1sgLy23CvRJK8', '2026-03-18 20:10:59.477389'),
('77u1s7ulpc34wxiufxk6thjc2cwfh7z2', '.eJyrViotTi2Kz0xRsjLSgbDz8nOTilKVrJSCEstSE1NyM_OUoDJF-TlAZbUA32ASAQ:1vw5RT:05tRjitjBL6b5Av7MztZYhvRbg85fk2zWHnZYg99J-U', '2026-03-13 21:32:11.483416'),
('7h651zc6fz8det7yeks3mfanr9syut9v', '.eJyrViotTi2Kz0xRsjLVgbDz8nOTilKVrJSCSwtSixQCikpTkxKVoJJF-TlKVoa1ABcCEvo:1vxpFX:ATAlzJu5Gn_efyYRunhwjTMoG7fsbAqWuUJSMvyah1k', '2026-03-18 16:39:03.791665'),
('9czn8q13q0k0gbwqxs8kdztukxnbx93o', '.eJyrViotTi2Kz0xRsjLVgbDz8nOTilKVrJSCSwtSixQCikpTkxKVoJJF-TlKVoa1ABcCEvo:1vxrzc:jGFH_l1fl5N-Ktru6iYMrrHu0e9HWA0dfy3o3wLsO5g', '2026-03-18 19:34:48.715864'),
('9dikh8vycul6syiypeaezrn2txlgfqc6', '.eJyrViotTi2Kz0xRsjLVgbDz8nOTilKVrJSCSwtSixQCikpTkxKVoJJF-TlKVoa1ABcCEvo:1vxruk:wuQVQd2FM9i8Y8fZV2niyS4P5N3USemZU_M40SbrGqY', '2026-03-18 19:29:46.924486'),
('a0n606qvnxbc6cn467op905eacx45cvx', '.eJyrViotTi2Kz0xRsjLVgbDz8nOTilKVrJSCSwtSixQCikpTkxKVoJJF-TlKVoa1ABcCEvo:1vxpTy:849lTpQtwGDjn1RTdL4D_kBhVE1TzHVpyM_KDud7pBc', '2026-03-18 16:53:58.573858'),
('a1bad3bpknixdp8ktdpbcxhh9sd7p0kf', '.eJyrViotTi2Kz0xRsjLVgbDz8nOTilKVrJSCSwtSixQCikpTkxKVoJJF-TlKVoa1ABcCEvo:1vxrwl:978n6fk8IYJpVUG79MZ5oQsLme6hYuVRwmFv_b0YpNY', '2026-03-18 19:31:51.566579'),
('a1rvlg2xhs6lvfsf7et1b3u9iraf2oor', '.eJyrViotTi2Kz0xRsjLVgbDz8nOTilKVrJSCSwtSixQCikpTkxKVoJJF-TlKVoa1ABcCEvo:1vxsrG:mqeH4fl9QWCp0dM2ixXnwNE9oNZUfhUGRut0fPXYPFY', '2026-03-18 20:30:14.969765'),
('damfd41vakrb951f9iqd9hjl91xowvfg', '.eJyrViotTi2Kz0xRsjLVgbDz8nOTilKVrJSCSwtSixQCikpTkxKVoJJF-TlKVoa1ABcCEvo:1vxp6v:y1f6vbLAuEFdH9JzOHoAxaeYF3x092niD2K7tCtQJPQ', '2026-03-18 16:30:09.845061'),
('dj65lpmxryeaau2093wlpyq654d3djoc', '.eJyrViotTi2Kz0xRsjLUgbDz8nOTilKVrJS88otTFYISy1KVoDJF-TlAZbUA2IARpw:1vxsZM:KxfYaTSQfJo5GEYyzy-BNUjava81GBnouv-r9TjYTp4', '2026-03-18 20:11:44.128866'),
('e5zzl9ratedwq72c5h9sy8rj5a0evuxv', '.eJyrViotTi2Kz0xRsjLUgbDz8nOTilKVrJS88otTFYISy1KVoDJF-TlAZbUA2IARpw:1vxsa4:X3Xi0wgbC96CIwM4V9hTA-NFA2dwLlxmleB98dxahJ4', '2026-03-18 20:12:28.017853'),
('j0ma4667onfqlub0a5af4xyny3ci7tty', '.eJyrViotTi2Kz0xRsjLSgbDz8nOTilKVrJSCEstSE1NyM_OUoDJF-TlAZbUA32ASAQ:1vw5W8:SCsfxbN5HVkGmhbfB32zYMpXLnuFeQPl9p4UbhmWcrs', '2026-03-13 21:37:00.827617'),
('jkzvxkg9myqywdf9522oiiwpqxzias6f', '.eJyrViotTi2Kz0xRsjLVgbDz8nOTilKVrJSCSwtSixQCikpTkxKVoJJF-TlKVoa1ABcCEvo:1vxs7A:I_rJFHLTvbZzL3vJMry67T_o7n8DJvs8FWOJoImzK6k', '2026-03-18 19:42:36.038484'),
('lrvrsuovnldyjotlmlf8yck4qsnf2l02', '.eJyrViotTi2Kz0xRsjLVgbDz8nOTilKVrJSCSwtSixQCikpTkxKVoJJF-TlKVoa1ABcCEvo:1vxp7u:WbPph2osd5h8EBSxd2tXq_T2_E7yMlaAcqF0OJ2eynU', '2026-03-18 16:31:10.585595'),
('lxrnefezo7ns229jnpbqjy5txfg550ik', '.eJyrViotTi2Kz0xRsjLVgbDz8nOTilKVrJSCSwtSixQCikpTkxKVoJJF-TlKVoa1ABcCEvo:1vxsIF:yELV0zQcFVGI-xEux2yy9lNzqoHJhhx3mQV8JMpZ1ag', '2026-03-18 19:54:03.249144'),
('m7ajze0diaej0ommna75hcsaj856gy5y', '.eJyrViotTi2Kz0xRsjLVgbDz8nOTilKVrJSCSwtSixQCikpTkxKVoJJF-TlKVoa1ABcCEvo:1vxp8E:-xKRsKUCoWqKT626O2a-lk8aqzRHzFOd0kC-9b4FcL0', '2026-03-18 16:31:30.229960'),
('mhkdhlxbpz969qclzh50ij2ww9bcq7gf', '.eJyrViotTi2Kz0xRsjLVgbDz8nOTilKVrJSCSwtSixQCikpTkxKVoJJF-TlKVoa1ABcCEvo:1vxrxc:wWXFR_BmoHmZ0UtdT94oiyesgO1nE1mzSs7drry2Hek', '2026-03-18 19:32:44.667133'),
('mih3wpp38cutkr4x585s6f87to6t3ui4', '.eJyrViotTi2Kz0xRsjLVgbDz8nOTilKVrJSCSwtSixQCikpTkxKVoJJF-TlKVoa1ABcCEvo:1vxs1x:W7ODa3nazkRN1erUqzLFixcuG9Gwzblnz6Mcze46yVc', '2026-03-18 19:37:13.427182'),
('ox9rftiqt3dorvot29p3w6g3v9k9wypa', '.eJyrViotTi2Kz0xRsjLUgbDz8nOTilKVrJS88otTFYISy1KVoDJF-TlAZbUA2IARpw:1vxscQ:SvKdlQ1KRvRkktRc_RUpcqGwu7JKEG8CFL9iC4yvhuQ', '2026-03-18 20:14:54.011092'),
('p8xqelnvzzp1eza8gfcj10mx6t3rsogr', '.eJyrViotTi2Kz0xRsjLVgbDz8nOTilKVrJSCSwtSixQCikpTkxKVoJJF-TlKVoa1ABcCEvo:1vxpY6:CisMLC55xK8DDSuvvOoW08nWJ-B51z-eA-SldU3ROXc', '2026-03-18 16:58:14.006657'),
('th7l3cgat97f0qja0chuuoj7afv4p1zx', '.eJyrViotTi2Kz0xRsjLVgbDz8nOTilKVrJSCSwtSixQCikpTkxKVoJJF-TlKVoa1ABcCEvo:1vxpAD:9zf59eMCBtKeXXqSyBWg_Qa2_5cBWWLKzPS9StN0Tpk', '2026-03-18 16:33:33.125825'),
('veb23xbkh85m04vqer81zkfomglwwtq0', '.eJyrViotTi2Kz0xRsjLVgbDz8nOTilKVrJSCSwtSixQCikpTkxKVoJJF-TlKVoa1ABcCEvo:1vxrfR:m5aBQUQM3hycBndMtYGwAlyBDEUTf9fBmEnzOKVfqZU', '2026-03-18 19:13:57.207172'),
('vxj21to7dsv20zrftd77p1llmjbas1b0', '.eJyrViotTi2Kz0xRsjLUgbDz8nOTilKVrJS88otTFYISy1KVoDJF-TlAZbUA2IARpw:1vxsrT:ugbcIpCckzqjqDUo64A-JxztIJeVWjH8yubkdKfmTtg', '2026-03-18 20:30:27.576270'),
('wyhm4p1exuesinvvusfdoqsan36jngs1', '.eJyrViotTi2Kz0xRsjLVgbDz8nOTilKVrJSCSwtSixQCikpTkxKVoJJF-TlKVoa1ABcCEvo:1vxp6E:CPXexMtZbzIMh3H8ZlqtipKDuhuxfE7hXOI4ac9vPQU', '2026-03-18 16:29:26.990893'),
('xi9o2hm59pej02ykf60606gwmehpdomr', '.eJyrViotTi2Kz0xRsjLVgbDz8nOTilKVrJSCSwtSixQCikpTkxKVoJJF-TlKVoa1ABcCEvo:1vxp65:kpgR8No5wYtoaE4-748H3LKO6i4Tho-AJJzcGkgA35A', '2026-03-18 16:29:17.679553');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `items_riesgos`
--

CREATE TABLE `items_riesgos` (
  `id_item_riesgo` int(11) NOT NULL,
  `id_area` int(11) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `criticidad` enum('baja','media','alta') NOT NULL,
  `estado` enum('activo','inactivo') DEFAULT 'activo',
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp(),
  `creado_por` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Volcado de datos para la tabla `items_riesgos`
--

INSERT INTO `items_riesgos` (`id_item_riesgo`, `id_area`, `nombre`, `descripcion`, `criticidad`, `estado`, `fecha_creacion`, `creado_por`) VALUES
(1, 1, 'Equipo de Cómputo - PC Administrativo', 'Activo tecnológico utilizado para procesos administrativos internos.', 'alta', 'activo', '2026-02-27 16:11:43', 1),
(3, 1, 'Prueba', 'blablablabla', 'media', 'activo', '2026-02-28 01:07:59', 2),
(5, 2, 'CELULAR DE ENDER', 'Este es el celular de ender', 'alta', 'activo', '2026-03-04 05:05:21', 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `item_responsable`
--

CREATE TABLE `item_responsable` (
  `id` int(11) NOT NULL,
  `id_item_riesgo` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `fecha_asignacion` timestamp NULL DEFAULT current_timestamp(),
  `asignado_por` int(11) NOT NULL,
  `estado` enum('activo','inactivo') DEFAULT 'activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Volcado de datos para la tabla `item_responsable`
--

INSERT INTO `item_responsable` (`id`, `id_item_riesgo`, `id_usuario`, `fecha_asignacion`, `asignado_por`, `estado`) VALUES
(2, 1, 4, '2026-02-27 16:11:43', 2, 'inactivo'),
(6, 1, 3, '2026-03-04 01:41:26', 3, 'activo'),
(7, 3, 3, '2026-03-04 01:44:01', 3, 'inactivo'),
(8, 5, 3, '2026-03-04 05:07:31', 3, 'activo'),
(9, 5, 1, '2026-03-04 19:41:28', 2, 'activo'),
(11, 5, 7, '2026-03-05 03:29:00', 2, 'activo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `registro_checks`
--

CREATE TABLE `registro_checks` (
  `id_check` int(11) NOT NULL,
  `id_control` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `fecha_check` date NOT NULL,
  `hora_check` timestamp NULL DEFAULT current_timestamp(),
  `estado` enum('cumple','no_cumple') NOT NULL,
  `observaciones` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Volcado de datos para la tabla `registro_checks`
--

INSERT INTO `registro_checks` (`id_check`, `id_control`, `id_usuario`, `fecha_check`, `hora_check`, `estado`, `observaciones`) VALUES
(1, 1, 3, '2026-02-27', '2026-02-27 16:11:43', 'cumple', 'Equipo funcionando correctamente.'),
(2, 2, 4, '2026-02-27', '2026-02-27 16:11:43', 'cumple', 'Antivirus actualizado correctamente.'),
(3, 2, 2, '2026-02-27', '2026-02-28 02:58:31', 'cumple', NULL),
(4, 2, 3, '2026-02-27', '2026-02-28 03:05:14', 'cumple', 'Esta funcionando correctamente'),
(5, 1, 2, '2026-02-27', '2026-02-28 03:05:29', 'cumple', 'todo good'),
(6, 1, 2, '2026-03-02', '2026-03-02 20:54:02', 'cumple', 'Hoy esta bien'),
(7, 1, 3, '2026-03-03', '2026-03-04 00:49:26', 'cumple', ''),
(8, 3, 3, '2026-03-03', '2026-03-04 01:05:04', 'cumple', ''),
(9, 2, 3, '2026-03-03', '2026-03-04 02:50:45', 'cumple', 'Todo correcto prueba de cantidad de texto aaaaaaaaaaaaaabbbbbbbbbbbcccccccccc'),
(10, 2, 2, '2026-03-04', '2026-03-04 18:01:25', 'cumple', 'PRUEBA MAXIMO TEXXTO PRUEBA MAXIMO TEXXTO PRUEBA MAXIMO TEXXTO PRUEBA MAXIMO TEXXTO PRUEBA MAXIMO TEXXTO PRUEBA MAXIMO TEXXTO PRUEBA MAXIMO TEXXTO PRUEBA MAXIMO TEXXTO aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'),
(11, 1, 2, '2026-03-04', '2026-03-04 20:31:28', 'cumple', ''),
(12, 4, 1, '2026-03-04', '2026-03-05 00:57:04', 'cumple', ''),
(13, 4, 7, '2026-03-04', '2026-03-05 03:29:36', 'cumple', ''),
(14, 4, 7, '2026-03-05', '2026-03-05 18:31:17', 'cumple', '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `riesgos`
--

CREATE TABLE `riesgos` (
  `id_riesgo` int(11) NOT NULL,
  `id_item_riesgo` int(11) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `nivel_riesgo` enum('bajo','medio','alto') NOT NULL,
  `estado` enum('activo','inactivo') DEFAULT 'activo',
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp(),
  `creado_por` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Volcado de datos para la tabla `riesgos`
--

INSERT INTO `riesgos` (`id_riesgo`, `id_item_riesgo`, `nombre`, `descripcion`, `nivel_riesgo`, `estado`, `fecha_creacion`, `creado_por`) VALUES
(1, 1, 'Falla de Hardware', 'Posible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasd Posible daño en componentes físicos del Posible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasdPosible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasdPosible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasdPosible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasdPosible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasdPosible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasdPosible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasdequipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasdPosible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasdPosible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasdPosible daño en componentes físicos del equipo. Revisar saasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasdasd', 'alto', 'activo', '2026-02-27 16:11:43', 1),
(2, 1, 'Infección por Malware', 'Riesgo de afectación por software malicioso.', 'alto', 'activo', '2026-02-27 16:11:43', 1),
(4, 5, 'Recalentamiento por Juegos', 'Este celular se recalienta muy facil por los juegos que tiene instalados', 'alto', 'activo', '2026-03-04 05:06:25', 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id_rol` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id_rol`, `nombre`, `descripcion`) VALUES
(1, 'Superadmin', 'Perfil con control total del sistema. Gestiona usuarios, sedes, áreas, ítems de riesgo, riesgos, controles y auditoría.'),
(2, 'Admin', 'Perfil encargado de la gestión operativa del sistema. Crea ítems de riesgo, define riesgos y asigna responsables.'),
(3, 'Responsable', 'Perfil operativo encargado de ejecutar y registrar la verificación periódica de los controles asignados.');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sedes`
--

CREATE TABLE `sedes` (
  `id_sede` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `estado` enum('activo','inactivo') DEFAULT 'activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Volcado de datos para la tabla `sedes`
--

INSERT INTO `sedes` (`id_sede`, `nombre`, `direccion`, `estado`) VALUES
(1, 'Manizales', 'Av. Santander #36-65, Manizales, Caldas', 'activo'),
(2, 'Armenia', 'Cra. 14 #44 N - 03, Armenia, Quindío', 'activo'),
(3, 'Pereira', 'Av. 30 de Agosto #41-71, Pereira, Risaralda', 'activo'),
(4, 'Default Sede', NULL, 'activo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `correo` varchar(150) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `estado` enum('activo','inactivo') DEFAULT 'activo',
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp(),
  `id_rol` int(11) NOT NULL,
  `id_sede` int(11) NOT NULL,
  `id_area` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `nombre`, `correo`, `password_hash`, `estado`, `fecha_creacion`, `id_rol`, `id_sede`, `id_area`) VALUES
(1, 'Jose Rave', 'rave@colautos.co', 'pbkdf2_sha256$1000000$X4YIHYnIamxroU2NMj4lgz$6+glSNDxxQmjmCK53o0o0IZrgm35+nZhvhSprbnfOpQ=', 'activo', '2026-02-27 16:11:42', 1, 1, 1),
(2, 'Raveadmin', 'raveadmin@colautos.co', 'pbkdf2_sha256$1000000$LQcWAZnwrm2sYNxz2x0cTE$hIKYQLZxo+lxhfOEkkF/wS9uulArfXob5euuz94UBuQ=', 'activo', '2026-02-27 16:11:42', 1, 1, 2),
(3, 'Andrés Torres', 'otroadmin@colautos.co', '12345', 'activo', '2026-02-27 16:11:42', 3, 3, 2),
(4, 'Mariana Ríos', 'mrios@empresa.com', 'hash_responsable2', 'inactivo', '2026-02-27 16:11:42', 3, 1, 1),
(5, 'Super Prueba', 'super@local.test', 'pbkdf2_sha256$1000000$RkGnM4vG0rn5O2yc3Z54Yy$ozuwWyAB5nFjWemiYDPPyF+/S6kt43RMH1+MwIBmC/Y=', 'activo', '2026-03-04 21:27:35', 2, 4, 3),
(7, 'El Señor Responsable', 'responsable@colautos.co', 'pbkdf2_sha256$1000000$ZpufshxBmgUvNf4gVigTf0$cahEZ5QKrlfiHvWlRL8hCV5AY7ZlpWCny7sG0s7V2ho=', 'activo', '2026-03-05 03:25:50', 3, 2, 2);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `areas`
--
ALTER TABLE `areas`
  ADD PRIMARY KEY (`id_area`),
  ADD KEY `id_sede` (`id_sede`);

--
-- Indices de la tabla `auditoria`
--
ALTER TABLE `auditoria`
  ADD PRIMARY KEY (`id_auditoria`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indices de la tabla `auth_group`
--
ALTER TABLE `auth_group`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indices de la tabla `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  ADD KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`);

--
-- Indices de la tabla `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`);

--
-- Indices de la tabla `auth_user`
--
ALTER TABLE `auth_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indices de la tabla `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  ADD KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`);

--
-- Indices de la tabla `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  ADD KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`);

--
-- Indices de la tabla `controles`
--
ALTER TABLE `controles`
  ADD PRIMARY KEY (`id_control`),
  ADD KEY `id_riesgo` (`id_riesgo`),
  ADD KEY `creado_por` (`creado_por`);

--
-- Indices de la tabla `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  ADD KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`);

--
-- Indices de la tabla `django_content_type`
--
ALTER TABLE `django_content_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`);

--
-- Indices de la tabla `django_migrations`
--
ALTER TABLE `django_migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `django_session`
--
ALTER TABLE `django_session`
  ADD PRIMARY KEY (`session_key`),
  ADD KEY `django_session_expire_date_a5c62663` (`expire_date`);

--
-- Indices de la tabla `items_riesgos`
--
ALTER TABLE `items_riesgos`
  ADD PRIMARY KEY (`id_item_riesgo`),
  ADD KEY `id_area` (`id_area`),
  ADD KEY `creado_por` (`creado_por`);

--
-- Indices de la tabla `item_responsable`
--
ALTER TABLE `item_responsable`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_item_riesgo` (`id_item_riesgo`,`id_usuario`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `asignado_por` (`asignado_por`);

--
-- Indices de la tabla `registro_checks`
--
ALTER TABLE `registro_checks`
  ADD PRIMARY KEY (`id_check`),
  ADD UNIQUE KEY `id_control` (`id_control`,`id_usuario`,`fecha_check`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indices de la tabla `riesgos`
--
ALTER TABLE `riesgos`
  ADD PRIMARY KEY (`id_riesgo`),
  ADD KEY `id_item_riesgo` (`id_item_riesgo`),
  ADD KEY `creado_por` (`creado_por`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id_rol`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `sedes`
--
ALTER TABLE `sedes`
  ADD PRIMARY KEY (`id_sede`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `correo` (`correo`),
  ADD KEY `id_rol` (`id_rol`),
  ADD KEY `id_sede` (`id_sede`),
  ADD KEY `id_area` (`id_area`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `areas`
--
ALTER TABLE `areas`
  MODIFY `id_area` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `auditoria`
--
ALTER TABLE `auditoria`
  MODIFY `id_auditoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=330;

--
-- AUTO_INCREMENT de la tabla `auth_group`
--
ALTER TABLE `auth_group`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `auth_permission`
--
ALTER TABLE `auth_permission`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT de la tabla `auth_user`
--
ALTER TABLE `auth_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `controles`
--
ALTER TABLE `controles`
  MODIFY `id_control` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `django_admin_log`
--
ALTER TABLE `django_admin_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `django_content_type`
--
ALTER TABLE `django_content_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `django_migrations`
--
ALTER TABLE `django_migrations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT de la tabla `items_riesgos`
--
ALTER TABLE `items_riesgos`
  MODIFY `id_item_riesgo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `item_responsable`
--
ALTER TABLE `item_responsable`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `registro_checks`
--
ALTER TABLE `registro_checks`
  MODIFY `id_check` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `riesgos`
--
ALTER TABLE `riesgos`
  MODIFY `id_riesgo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `id_rol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `sedes`
--
ALTER TABLE `sedes`
  MODIFY `id_sede` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `areas`
--
ALTER TABLE `areas`
  ADD CONSTRAINT `areas_ibfk_1` FOREIGN KEY (`id_sede`) REFERENCES `sedes` (`id_sede`);

--
-- Filtros para la tabla `auditoria`
--
ALTER TABLE `auditoria`
  ADD CONSTRAINT `auditoria_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Filtros para la tabla `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Filtros para la tabla `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  ADD CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Filtros para la tabla `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Filtros para la tabla `controles`
--
ALTER TABLE `controles`
  ADD CONSTRAINT `controles_ibfk_1` FOREIGN KEY (`id_riesgo`) REFERENCES `riesgos` (`id_riesgo`),
  ADD CONSTRAINT `controles_ibfk_2` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  ADD CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Filtros para la tabla `items_riesgos`
--
ALTER TABLE `items_riesgos`
  ADD CONSTRAINT `items_riesgos_ibfk_1` FOREIGN KEY (`id_area`) REFERENCES `areas` (`id_area`),
  ADD CONSTRAINT `items_riesgos_ibfk_2` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `item_responsable`
--
ALTER TABLE `item_responsable`
  ADD CONSTRAINT `item_responsable_ibfk_1` FOREIGN KEY (`id_item_riesgo`) REFERENCES `items_riesgos` (`id_item_riesgo`),
  ADD CONSTRAINT `item_responsable_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`),
  ADD CONSTRAINT `item_responsable_ibfk_3` FOREIGN KEY (`asignado_por`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `registro_checks`
--
ALTER TABLE `registro_checks`
  ADD CONSTRAINT `registro_checks_ibfk_1` FOREIGN KEY (`id_control`) REFERENCES `controles` (`id_control`),
  ADD CONSTRAINT `registro_checks_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `riesgos`
--
ALTER TABLE `riesgos`
  ADD CONSTRAINT `riesgos_ibfk_1` FOREIGN KEY (`id_item_riesgo`) REFERENCES `items_riesgos` (`id_item_riesgo`),
  ADD CONSTRAINT `riesgos_ibfk_2` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `usuarios_ibfk_1` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id_rol`),
  ADD CONSTRAINT `usuarios_ibfk_2` FOREIGN KEY (`id_sede`) REFERENCES `sedes` (`id_sede`),
  ADD CONSTRAINT `usuarios_ibfk_3` FOREIGN KEY (`id_area`) REFERENCES `areas` (`id_area`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
