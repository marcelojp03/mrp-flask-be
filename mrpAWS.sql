--
-- PostgreSQL database dump
--

\restrict 8HW0MHddggHkuQO8UF5K7NrWIMY21ogMkB5nBQNLHT0VhALG9dhUAgHnskE6eAx

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

-- Started on 2025-11-08 16:51:01

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
--SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = mrp, pg_catalog;

-- Crear esquema si no existe
CREATE SCHEMA IF NOT EXISTS mrp;

-- Drop constraints solo si existen (no genera error si no existen)
DO $$ 
BEGIN
    -- Desactivar triggers temporalmente
    SET session_replication_role = replica;
END $$;

ALTER TABLE IF EXISTS mrp.work_order DROP CONSTRAINT IF EXISTS IF EXISTS work_order_warehouse_id_fkey;
ALTER TABLE IF EXISTS mrp.work_order DROP CONSTRAINT IF EXISTS work_order_product_id_fkey;
ALTER TABLE IF EXISTS mrp.work_order DROP CONSTRAINT IF EXISTS work_order_org_id_fkey;
ALTER TABLE IF EXISTS mrp.work_order DROP CONSTRAINT IF EXISTS work_order_created_by_fkey;
ALTER TABLE IF EXISTS mrp.work_order DROP CONSTRAINT IF EXISTS work_order_bom_id_fkey;
ALTER TABLE IF EXISTS mrp.work_order DROP CONSTRAINT IF EXISTS work_order_assigned_to_fkey;
ALTER TABLE IF EXISTS mrp.warehouse DROP CONSTRAINT IF EXISTS warehouse_org_id_fkey;
ALTER TABLE IF EXISTS mrp.user_role DROP CONSTRAINT IF EXISTS user_role_user_id_fkey;
ALTER TABLE IF EXISTS mrp.user_role DROP CONSTRAINT IF EXISTS user_role_role_id_fkey;
ALTER TABLE IF EXISTS mrp.user_organization DROP CONSTRAINT IF EXISTS user_organization_user_id_fkey;
ALTER TABLE IF EXISTS mrp.user_organization DROP CONSTRAINT IF EXISTS user_organization_org_id_fkey;
ALTER TABLE IF EXISTS mrp.system_log DROP CONSTRAINT IF EXISTS system_log_user_id_fkey;
ALTER TABLE IF EXISTS mrp.system_log DROP CONSTRAINT IF EXISTS system_log_org_id_fkey;
ALTER TABLE IF EXISTS mrp.supplier DROP CONSTRAINT IF EXISTS supplier_org_id_fkey;
ALTER TABLE IF EXISTS mrp.supplier_item DROP CONSTRAINT IF EXISTS supplier_item_supplier_id_fkey;
ALTER TABLE IF EXISTS mrp.supplier_item DROP CONSTRAINT IF EXISTS supplier_item_product_id_fkey;
ALTER TABLE IF EXISTS mrp.supplier_item DROP CONSTRAINT IF EXISTS supplier_item_org_id_fkey;
ALTER TABLE IF EXISTS mrp.subresource DROP CONSTRAINT IF EXISTS subresource_resource_id_fkey;
ALTER TABLE IF EXISTS mrp.role_resource DROP CONSTRAINT IF EXISTS role_resource_subresource_id_fkey;
ALTER TABLE IF EXISTS mrp.role_resource DROP CONSTRAINT IF EXISTS role_resource_role_id_fkey;
ALTER TABLE IF EXISTS mrp.role_resource DROP CONSTRAINT IF EXISTS role_resource_resource_id_fkey;
ALTER TABLE IF EXISTS mrp.report_audit DROP CONSTRAINT IF EXISTS report_audit_user_id_fkey;
ALTER TABLE IF EXISTS mrp.report_audit DROP CONSTRAINT IF EXISTS report_audit_org_id_fkey;
ALTER TABLE IF EXISTS mrp.purchase DROP CONSTRAINT IF EXISTS purchase_warehouse_id_fkey;
ALTER TABLE IF EXISTS mrp.purchase DROP CONSTRAINT IF EXISTS purchase_user_id_fkey;
ALTER TABLE IF EXISTS mrp.purchase DROP CONSTRAINT IF EXISTS purchase_supplier_id_fkey;
ALTER TABLE IF EXISTS mrp.purchase DROP CONSTRAINT IF EXISTS purchase_org_id_fkey;
ALTER TABLE IF EXISTS mrp.purchase_detail DROP CONSTRAINT IF EXISTS purchase_detail_purchase_id_fkey;
ALTER TABLE IF EXISTS mrp.purchase_detail DROP CONSTRAINT IF EXISTS purchase_detail_product_id_fkey;
ALTER TABLE IF EXISTS mrp.product_warehouse DROP CONSTRAINT IF EXISTS product_warehouse_warehouseid_fkey;
ALTER TABLE IF EXISTS mrp.product_warehouse DROP CONSTRAINT IF EXISTS product_warehouse_productid_fkey;
ALTER TABLE IF EXISTS mrp.product DROP CONSTRAINT IF EXISTS product_unit_id_fkey;
ALTER TABLE IF EXISTS mrp.product DROP CONSTRAINT IF EXISTS product_org_id_fkey;
ALTER TABLE IF EXISTS mrp.org_subscription DROP CONSTRAINT IF EXISTS org_subscription_plan_id_fkey;
ALTER TABLE IF EXISTS mrp.org_subscription DROP CONSTRAINT IF EXISTS org_subscription_org_id_fkey;
ALTER TABLE IF EXISTS mrp.movement DROP CONSTRAINT IF EXISTS movement_to_warehouse_id_fkey;
ALTER TABLE IF EXISTS mrp.movement DROP CONSTRAINT IF EXISTS movement_product_id_fkey;
ALTER TABLE IF EXISTS mrp.movement DROP CONSTRAINT IF EXISTS movement_org_id_fkey;
ALTER TABLE IF EXISTS mrp.movement DROP CONSTRAINT IF EXISTS movement_from_warehouse_id_fkey;
ALTER TABLE IF EXISTS mrp.movement DROP CONSTRAINT IF EXISTS movement_created_by_fkey;
ALTER TABLE IF EXISTS mrp.bom DROP CONSTRAINT IF EXISTS bom_product_id_fkey;
ALTER TABLE IF EXISTS mrp.bom DROP CONSTRAINT IF EXISTS bom_org_id_fkey;
ALTER TABLE IF EXISTS mrp.bom_component DROP CONSTRAINT IF EXISTS bom_component_unit_id_fkey;
ALTER TABLE IF EXISTS mrp.bom_component DROP CONSTRAINT IF EXISTS bom_component_component_id_fkey;
ALTER TABLE IF EXISTS mrp.bom_component DROP CONSTRAINT IF EXISTS bom_component_bom_id_fkey;
DROP INDEX IF EXISTS mrp.ix_user_org_default;
DROP INDEX IF EXISTS mrp.ix_system_log_user_id;
DROP INDEX IF EXISTS mrp.ix_system_log_ts;
DROP INDEX IF EXISTS mrp.ix_system_log_org_id;
DROP INDEX IF EXISTS mrp.ix_report_audit_ts;
DROP INDEX IF EXISTS mrp.ix_report_audit_org_id;
DROP INDEX IF EXISTS mrp.ix_product_warehouse_warehouse;
DROP INDEX IF EXISTS mrp.ix_product_warehouse_product;
DROP INDEX IF EXISTS mrp.ix_movement_to_warehouse;
DROP INDEX IF EXISTS mrp.ix_movement_product_id;
DROP INDEX IF EXISTS mrp.ix_movement_from_warehouse;
DROP INDEX IF EXISTS mrp.ix_movement_created_at;
DROP INDEX IF EXISTS mrp.idx_work_order_warehouse_id;
DROP INDEX IF EXISTS mrp.idx_work_order_status;
DROP INDEX IF EXISTS mrp.idx_work_order_product_id;
DROP INDEX IF EXISTS mrp.idx_work_order_org_id;
DROP INDEX IF EXISTS mrp.idx_work_order_created_at;
DROP INDEX IF EXISTS mrp.idx_work_order_bom_id;
DROP INDEX IF EXISTS mrp.idx_work_order_assigned_to;
DROP INDEX IF EXISTS mrp.idx_movement_reference_type;
DROP INDEX IF EXISTS mrp.idx_movement_reference_id;
DROP INDEX IF EXISTS mrp.idx_movement_reference_composite;
DROP INDEX IF EXISTS mrp.idx_bom_product_id;
DROP INDEX IF EXISTS mrp.idx_bom_org_id;
DROP INDEX IF EXISTS mrp.idx_bom_is_active;
DROP INDEX IF EXISTS mrp.idx_bom_component_component_id;
DROP INDEX IF EXISTS mrp.idx_bom_component_bom_id;
ALTER TABLE IF EXISTS mrp.work_order DROP CONSTRAINT IF EXISTS work_order_pkey;
ALTER TABLE IF EXISTS mrp.warehouse DROP CONSTRAINT IF EXISTS warehouse_pkey;
ALTER TABLE IF EXISTS mrp.user_role DROP CONSTRAINT IF EXISTS user_role_pkey;
ALTER TABLE IF EXISTS mrp."user" DROP CONSTRAINT IF EXISTS user_pkey;
ALTER TABLE IF EXISTS mrp."user" DROP CONSTRAINT IF EXISTS user_email_key;
ALTER TABLE IF EXISTS mrp.user_organization DROP CONSTRAINT IF EXISTS uq_user_org;
ALTER TABLE IF EXISTS mrp.supplier_item DROP CONSTRAINT IF EXISTS uq_supplier_item_prod_sup;
ALTER TABLE IF EXISTS mrp.product_warehouse DROP CONSTRAINT IF EXISTS uq_product_warehouse;
ALTER TABLE IF EXISTS mrp.product DROP CONSTRAINT IF EXISTS uq_product_org_code;
ALTER TABLE IF EXISTS mrp.bom DROP CONSTRAINT IF EXISTS uq_bom_product_version;
ALTER TABLE IF EXISTS mrp.bom_component DROP CONSTRAINT IF EXISTS uq_bom_component;
ALTER TABLE IF EXISTS mrp.unit DROP CONSTRAINT IF EXISTS unit_pkey;
ALTER TABLE IF EXISTS mrp.system_log DROP CONSTRAINT IF EXISTS system_log_pkey;
ALTER TABLE IF EXISTS mrp.supplier DROP CONSTRAINT IF EXISTS supplier_pkey;
ALTER TABLE IF EXISTS mrp.supplier_item DROP CONSTRAINT IF EXISTS supplier_item_pkey;
ALTER TABLE IF EXISTS mrp.subresource DROP CONSTRAINT IF EXISTS subresource_pkey;
ALTER TABLE IF EXISTS mrp.role_resource DROP CONSTRAINT IF EXISTS role_resource_pkey;
ALTER TABLE IF EXISTS mrp.role DROP CONSTRAINT IF EXISTS role_pkey;
ALTER TABLE IF EXISTS mrp.role DROP CONSTRAINT IF EXISTS role_name_key;
ALTER TABLE IF EXISTS mrp.role DROP CONSTRAINT IF EXISTS role_description_key;
ALTER TABLE IF EXISTS mrp.resource DROP CONSTRAINT IF EXISTS resource_pkey;
ALTER TABLE IF EXISTS mrp.report_audit DROP CONSTRAINT IF EXISTS report_audit_pkey;
ALTER TABLE IF EXISTS mrp.purchase DROP CONSTRAINT IF EXISTS purchase_pkey;
ALTER TABLE IF EXISTS mrp.purchase_detail DROP CONSTRAINT IF EXISTS purchase_detail_pkey;
ALTER TABLE IF EXISTS mrp.product_warehouse DROP CONSTRAINT IF EXISTS product_warehouse_pkey;
ALTER TABLE IF EXISTS mrp.product DROP CONSTRAINT IF EXISTS product_pkey;
ALTER TABLE IF EXISTS mrp.plan DROP CONSTRAINT IF EXISTS plan_pkey;
ALTER TABLE IF EXISTS mrp.plan DROP CONSTRAINT IF EXISTS plan_code_key;
ALTER TABLE IF EXISTS mrp.organization DROP CONSTRAINT IF EXISTS organization_pkey;
ALTER TABLE IF EXISTS mrp.organization DROP CONSTRAINT IF EXISTS organization_code_key;
ALTER TABLE IF EXISTS mrp.org_subscription DROP CONSTRAINT IF EXISTS org_subscription_pkey;
ALTER TABLE IF EXISTS mrp.org_subscription DROP CONSTRAINT IF EXISTS org_subscription_org_id_key;
ALTER TABLE IF EXISTS mrp.movement DROP CONSTRAINT IF EXISTS movement_pkey;
ALTER TABLE IF EXISTS mrp.drawer DROP CONSTRAINT IF EXISTS drawer_pkey;
ALTER TABLE IF EXISTS mrp.category DROP CONSTRAINT IF EXISTS category_pkey;
ALTER TABLE IF EXISTS mrp.bom DROP CONSTRAINT IF EXISTS bom_pkey;
ALTER TABLE IF EXISTS mrp.bom_component DROP CONSTRAINT IF EXISTS bom_component_pkey;
ALTER TABLE mrp.work_order ALTER COLUMN id DROP DEFAULT;
ALTER TABLE mrp.warehouse ALTER COLUMN id DROP DEFAULT;
ALTER TABLE mrp."user" ALTER COLUMN id DROP DEFAULT;
ALTER TABLE mrp.unit ALTER COLUMN id DROP DEFAULT;
ALTER TABLE mrp.system_log ALTER COLUMN id DROP DEFAULT;
ALTER TABLE mrp.supplier_item ALTER COLUMN id DROP DEFAULT;
ALTER TABLE mrp.supplier ALTER COLUMN id DROP DEFAULT;
ALTER TABLE mrp.subresource ALTER COLUMN id DROP DEFAULT;
ALTER TABLE mrp.role ALTER COLUMN id DROP DEFAULT;
ALTER TABLE mrp.resource ALTER COLUMN id DROP DEFAULT;
ALTER TABLE mrp.report_audit ALTER COLUMN id DROP DEFAULT;
ALTER TABLE mrp.purchase_detail ALTER COLUMN id DROP DEFAULT;
ALTER TABLE mrp.purchase ALTER COLUMN id DROP DEFAULT;
ALTER TABLE mrp.product_warehouse ALTER COLUMN id DROP DEFAULT;
ALTER TABLE mrp.product ALTER COLUMN id DROP DEFAULT;
ALTER TABLE mrp.plan ALTER COLUMN id DROP DEFAULT;
ALTER TABLE mrp.organization ALTER COLUMN id DROP DEFAULT;
ALTER TABLE mrp.org_subscription ALTER COLUMN id DROP DEFAULT;
ALTER TABLE mrp.movement ALTER COLUMN id DROP DEFAULT;
ALTER TABLE mrp.drawer ALTER COLUMN drawerid DROP DEFAULT;
ALTER TABLE mrp.category ALTER COLUMN categoryid DROP DEFAULT;
ALTER TABLE mrp.bom_component ALTER COLUMN id DROP DEFAULT;
ALTER TABLE mrp.bom ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE mrp.work_order_id_seq;
DROP TABLE mrp.work_order;
DROP SEQUENCE mrp.warehouse_id_seq;
DROP TABLE mrp.warehouse;
DROP TABLE mrp.user_role;
DROP TABLE mrp.user_organization;
DROP SEQUENCE mrp.user_id_seq;
DROP TABLE mrp."user";
DROP SEQUENCE mrp.unit_id_seq;
DROP TABLE mrp.unit;
DROP SEQUENCE mrp.system_log_id_seq;
DROP TABLE mrp.system_log;
DROP SEQUENCE mrp.supplier_item_id_seq;
DROP TABLE mrp.supplier_item;
DROP SEQUENCE mrp.supplier_id_seq;
DROP TABLE mrp.supplier;
DROP SEQUENCE mrp.subresource_id_seq;
DROP TABLE mrp.subresource;
DROP TABLE mrp.role_resource;
DROP SEQUENCE mrp.role_id_seq;
DROP TABLE mrp.role;
DROP SEQUENCE mrp.resource_id_seq;
DROP TABLE mrp.resource;
DROP SEQUENCE mrp.report_audit_id_seq;
DROP TABLE mrp.report_audit;
DROP SEQUENCE mrp.purchase_id_seq;
DROP SEQUENCE mrp.purchase_detail_id_seq;
DROP TABLE mrp.purchase_detail;
DROP TABLE mrp.purchase;
DROP SEQUENCE mrp.product_warehouse_id_seq;
DROP TABLE mrp.product_warehouse;
DROP SEQUENCE mrp.product_id_seq;
DROP TABLE mrp.product;
DROP SEQUENCE mrp.plan_id_seq;
DROP TABLE mrp.plan;
DROP SEQUENCE mrp.organization_id_seq;
DROP TABLE mrp.organization;
DROP SEQUENCE mrp.org_subscription_id_seq;
DROP TABLE mrp.org_subscription;
DROP SEQUENCE mrp.movement_id_seq;
DROP TABLE mrp.movement;
DROP SEQUENCE mrp.drawer_drawerid_seq;
DROP TABLE mrp.drawer;
DROP SEQUENCE mrp.category_categoryid_seq;
DROP TABLE mrp.category;
DROP SEQUENCE mrp.bom_id_seq;
DROP SEQUENCE mrp.bom_component_id_seq;
DROP TABLE mrp.bom_component;
DROP TABLE mrp.bom;
DROP TYPE mrp.subscription_status;
DROP TYPE mrp.procurement_type;
DROP TYPE mrp.movement_type;
DROP TYPE mrp.movement_reason;
DROP TYPE mrp.item_type;
--
-- TOC entry 897 (class 1247 OID 30640)
-- Name: item_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE mrp.item_type AS ENUM (
    'RM',
    'WIP',
    'FG',
    'CONSUMABLE',
    'SERVICE',
    'KIT'
);


--
-- TOC entry 903 (class 1247 OID 30664)
-- Name: movement_reason; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE mrp.movement_reason AS ENUM (
    'PURCHASE',
    'CONSUMPTION',
    'TRANSFER',
    'PRODUCTION',
    'ADJUSTMENT',
    'RETURN',
    'OTHER'
);


--
-- TOC entry 900 (class 1247 OID 30654)
-- Name: movement_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE mrp.movement_type AS ENUM (
    'IN',
    'OUT',
    'TRANSFER',
    'ADJUST'
);


--
-- TOC entry 894 (class 1247 OID 30634)
-- Name: procurement_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE mrp.procurement_type AS ENUM (
    'MAKE',
    'BUY'
);


--
-- TOC entry 951 (class 1247 OID 38638)
-- Name: subscription_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE mrp.subscription_status AS ENUM (
    'active',
    'canceled',
    'past_due'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 261 (class 1259 OID 38794)
-- Name: bom; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mrp.bom (
    id integer NOT NULL,
    org_id integer NOT NULL,
    product_id integer NOT NULL,
    version character varying(50) DEFAULT '1.0'::character varying NOT NULL,
    is_active boolean DEFAULT false NOT NULL,
    description character varying(500),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- TOC entry 5300 (class 0 OID 0)
-- Dependencies: 261
-- Name: TABLE bom; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE mrp.bom IS 'Bill of Materials (Lista de Materiales) - Define qué componentes se necesitan para fabricar un producto';


--
-- TOC entry 5301 (class 0 OID 0)
-- Dependencies: 261
-- Name: COLUMN bom.version; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN mrp.bom.version IS 'Versión de la BOM (ej: 1.0, 1.1, 2.0)';


--
-- TOC entry 5302 (class 0 OID 0)
-- Dependencies: 261
-- Name: COLUMN bom.is_active; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN mrp.bom.is_active IS 'Solo una versión de BOM puede estar activa por producto';


--
-- TOC entry 263 (class 1259 OID 38822)
-- Name: bom_component; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mrp.bom_component (
    id integer NOT NULL,
    bom_id integer NOT NULL,
    component_id integer NOT NULL,
    quantity numeric(10,4) NOT NULL,
    scrap_percentage numeric(5,2) DEFAULT 0.0 NOT NULL,
    unit_id integer,
    sequence integer DEFAULT 0,
    notes character varying(500),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT ck_bom_component_quantity_positive CHECK ((quantity > (0)::numeric)),
    CONSTRAINT ck_bom_component_scrap_range CHECK (((scrap_percentage >= (0)::numeric) AND (scrap_percentage <= (100)::numeric)))
);


--
-- TOC entry 5303 (class 0 OID 0)
-- Dependencies: 263
-- Name: TABLE bom_component; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE mrp.bom_component IS 'Componentes de la BOM - Materiales y cantidades necesarias';


--
-- TOC entry 5304 (class 0 OID 0)
-- Dependencies: 263
-- Name: COLUMN bom_component.quantity; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN mrp.bom_component.quantity IS 'Cantidad necesaria del componente';


--
-- TOC entry 5305 (class 0 OID 0)
-- Dependencies: 263
-- Name: COLUMN bom_component.scrap_percentage; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN mrp.bom_component.scrap_percentage IS 'Porcentaje de desperdicio esperado (0-100)';


--
-- TOC entry 5306 (class 0 OID 0)
-- Dependencies: 263
-- Name: COLUMN bom_component.sequence; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN mrp.bom_component.sequence IS 'Orden de los componentes en la lista';


--
-- TOC entry 262 (class 1259 OID 38821)
-- Name: bom_component_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mrp.bom_component_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5307 (class 0 OID 0)
-- Dependencies: 262
-- Name: bom_component_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mrp.bom_component_id_seq OWNED BY mrp.bom_component.id;


--
-- TOC entry 260 (class 1259 OID 38793)
-- Name: bom_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mrp.bom_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5308 (class 0 OID 0)
-- Dependencies: 260
-- Name: bom_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mrp.bom_id_seq OWNED BY mrp.bom.id;


--
-- TOC entry 259 (class 1259 OID 38787)
-- Name: category; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mrp.category (
    categoryid integer NOT NULL,
    code character varying(50),
    name character varying(100) NOT NULL,
    description character varying(200),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    created_by integer,
    updated_by integer,
    status integer NOT NULL,
    folder character varying(100),
    companyid_by integer
);


--
-- TOC entry 258 (class 1259 OID 38786)
-- Name: category_categoryid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mrp.category_categoryid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5309 (class 0 OID 0)
-- Dependencies: 258
-- Name: category_categoryid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mrp.category_categoryid_seq OWNED BY mrp.category.categoryid;


--
-- TOC entry 245 (class 1259 OID 38653)
-- Name: drawer; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mrp.drawer (
    drawerid integer NOT NULL,
    drawercode character varying(50),
    cantdivisiones integer,
    cantdivlibres integer
);


--
-- TOC entry 244 (class 1259 OID 38652)
-- Name: drawer_drawerid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mrp.drawer_drawerid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5310 (class 0 OID 0)
-- Dependencies: 244
-- Name: drawer_drawerid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mrp.drawer_drawerid_seq OWNED BY mrp.drawer.drawerid;


--
-- TOC entry 241 (class 1259 OID 31010)
-- Name: movement; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mrp.movement (
    id integer NOT NULL,
    org_id integer DEFAULT 1 NOT NULL,
    product_id integer NOT NULL,
    from_warehouse_id integer,
    to_warehouse_id integer,
    movement_type mrp.movement_type NOT NULL,
    reason mrp.movement_reason NOT NULL,
    quantity numeric(18,6) NOT NULL,
    reference_id character varying(80),
    reference_type character varying(40),
    note character varying(255),
    created_by integer,
    created_at timestamp without time zone NOT NULL,
    CONSTRAINT ck_movement_qty_pos CHECK ((quantity > (0)::numeric)),
    CONSTRAINT ck_movement_reference_type CHECK (((reference_type IS NULL) OR ((reference_type)::text = ANY ((ARRAY['WO'::character varying, 'PO'::character varying, 'SO'::character varying, 'ADJ'::character varying, 'TRANSFER'::character varying, 'RETURN'::character varying])::text[]))))
);


--
-- TOC entry 5311 (class 0 OID 0)
-- Dependencies: 241
-- Name: COLUMN movement.reference_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN mrp.movement.reference_id IS 'ID de la referencia (work_order.id, compra.id, etc)';


--
-- TOC entry 5312 (class 0 OID 0)
-- Dependencies: 241
-- Name: COLUMN movement.reference_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN mrp.movement.reference_type IS 'Tipo de referencia: WO (Work Order), PO (Purchase Order), SO (Sales Order), ADJ (Adjustment), etc';


--
-- TOC entry 240 (class 1259 OID 31009)
-- Name: movement_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mrp.movement_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5313 (class 0 OID 0)
-- Dependencies: 240
-- Name: movement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mrp.movement_id_seq OWNED BY mrp.movement.id;


--
-- TOC entry 257 (class 1259 OID 38767)
-- Name: org_subscription; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mrp.org_subscription (
    id integer NOT NULL,
    org_id integer NOT NULL,
    plan_id integer NOT NULL,
    status mrp.subscription_status DEFAULT 'active'::mrp.subscription_status NOT NULL,
    started_at timestamp without time zone NOT NULL,
    trial_until timestamp without time zone,
    max_users_override integer,
    max_products_override integer,
    max_warehouses_override integer,
    max_movements_per_day_override integer
);


--
-- TOC entry 256 (class 1259 OID 38766)
-- Name: org_subscription_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mrp.org_subscription_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5314 (class 0 OID 0)
-- Dependencies: 256
-- Name: org_subscription_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mrp.org_subscription_id_seq OWNED BY mrp.org_subscription.id;


--
-- TOC entry 218 (class 1259 OID 30711)
-- Name: organization; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mrp.organization (
    id integer NOT NULL,
    name character varying(120) NOT NULL,
    code character varying(60) NOT NULL,
    is_active boolean DEFAULT true NOT NULL
);


--
-- TOC entry 217 (class 1259 OID 30710)
-- Name: organization_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mrp.organization_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5315 (class 0 OID 0)
-- Dependencies: 217
-- Name: organization_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mrp.organization_id_seq OWNED BY mrp.organization.id;


--
-- TOC entry 249 (class 1259 OID 38688)
-- Name: plan; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mrp.plan (
    id integer NOT NULL,
    code character varying(40) NOT NULL,
    name character varying(80) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    max_users integer DEFAULT 3 NOT NULL,
    max_products integer DEFAULT 200 NOT NULL,
    max_warehouses integer DEFAULT 2 NOT NULL,
    max_movements_per_day integer DEFAULT 500 NOT NULL,
    max_ai_reports_per_day integer DEFAULT 10 NOT NULL,
    allow_bom boolean DEFAULT false NOT NULL,
    allow_work_orders boolean DEFAULT false NOT NULL,
    allow_mrp boolean DEFAULT false NOT NULL,
    allow_forecast boolean DEFAULT false NOT NULL
);


--
-- TOC entry 248 (class 1259 OID 38687)
-- Name: plan_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mrp.plan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5316 (class 0 OID 0)
-- Dependencies: 248
-- Name: plan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mrp.plan_id_seq OWNED BY mrp.plan.id;


--
-- TOC entry 224 (class 1259 OID 30769)
-- Name: product; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mrp.product (
    id integer NOT NULL,
    org_id integer DEFAULT 1 NOT NULL,
    code character varying(50) NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(200),
    unit_id integer,
    min_stock numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    procurement_type mrp.procurement_type DEFAULT 'BUY'::mrp.procurement_type NOT NULL,
    item_type mrp.item_type DEFAULT 'FG'::mrp.item_type NOT NULL,
    status boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT ck_product_min_stock_nonneg CHECK ((min_stock >= (0)::numeric))
);


--
-- TOC entry 223 (class 1259 OID 30768)
-- Name: product_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mrp.product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5317 (class 0 OID 0)
-- Dependencies: 223
-- Name: product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mrp.product_id_seq OWNED BY mrp.product.id;


--
-- TOC entry 228 (class 1259 OID 30827)
-- Name: product_warehouse; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mrp.product_warehouse (
    id integer NOT NULL,
    productid integer NOT NULL,
    warehouseid integer NOT NULL,
    stock numeric(10,2) DEFAULT '0'::numeric NOT NULL
);


--
-- TOC entry 227 (class 1259 OID 30826)
-- Name: product_warehouse_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mrp.product_warehouse_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5318 (class 0 OID 0)
-- Dependencies: 227
-- Name: product_warehouse_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mrp.product_warehouse_id_seq OWNED BY mrp.product_warehouse.id;


--
-- TOC entry 247 (class 1259 OID 38660)
-- Name: purchase; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mrp.purchase (
    id integer NOT NULL,
    org_id integer DEFAULT 1 NOT NULL,
    order_number integer NOT NULL,
    date timestamp without time zone NOT NULL,
    user_id integer NOT NULL,
    supplier_id integer NOT NULL,
    warehouse_id integer NOT NULL,
    total numeric(10,2) NOT NULL,
    status character varying(50) NOT NULL
);


--
-- TOC entry 255 (class 1259 OID 38750)
-- Name: purchase_detail; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mrp.purchase_detail (
    id integer NOT NULL,
    purchase_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer NOT NULL,
    price numeric(10,2) NOT NULL,
    total numeric(10,2) NOT NULL
);


--
-- TOC entry 254 (class 1259 OID 38749)
-- Name: purchase_detail_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mrp.purchase_detail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5319 (class 0 OID 0)
-- Dependencies: 254
-- Name: purchase_detail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mrp.purchase_detail_id_seq OWNED BY mrp.purchase_detail.id;


--
-- TOC entry 246 (class 1259 OID 38659)
-- Name: purchase_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mrp.purchase_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5320 (class 0 OID 0)
-- Dependencies: 246
-- Name: purchase_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mrp.purchase_id_seq OWNED BY mrp.purchase.id;


--
-- TOC entry 253 (class 1259 OID 38729)
-- Name: report_audit; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mrp.report_audit (
    id integer NOT NULL,
    ts timestamp without time zone NOT NULL,
    user_id integer NOT NULL,
    org_id integer NOT NULL,
    prompt text NOT NULL,
    sql text,
    rowcount integer,
    error text,
    took_ms integer
);


--
-- TOC entry 252 (class 1259 OID 38728)
-- Name: report_audit_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mrp.report_audit_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5321 (class 0 OID 0)
-- Dependencies: 252
-- Name: report_audit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mrp.report_audit_id_seq OWNED BY mrp.report_audit.id;


--
-- TOC entry 236 (class 1259 OID 30959)
-- Name: resource; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mrp.resource (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    description character varying(200)
);


--
-- TOC entry 235 (class 1259 OID 30958)
-- Name: resource_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mrp.resource_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5322 (class 0 OID 0)
-- Dependencies: 235
-- Name: resource_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mrp.resource_id_seq OWNED BY mrp.resource.id;


--
-- TOC entry 234 (class 1259 OID 30947)
-- Name: role; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mrp.role (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    description character varying(100),
    status boolean DEFAULT true
);


--
-- TOC entry 233 (class 1259 OID 30946)
-- Name: role_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mrp.role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5323 (class 0 OID 0)
-- Dependencies: 233
-- Name: role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mrp.role_id_seq OWNED BY mrp.role.id;


--
-- TOC entry 242 (class 1259 OID 31047)
-- Name: role_resource; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mrp.role_resource (
    role_id integer NOT NULL,
    resource_id integer NOT NULL,
    subresource_id integer NOT NULL
);


--
-- TOC entry 239 (class 1259 OID 30981)
-- Name: subresource; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mrp.subresource (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(50) NOT NULL,
    description character varying(200),
    url character varying(100),
    icon character varying(80)
);


--
-- TOC entry 238 (class 1259 OID 30980)
-- Name: subresource_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mrp.subresource_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5324 (class 0 OID 0)
-- Dependencies: 238
-- Name: subresource_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mrp.subresource_id_seq OWNED BY mrp.subresource.id;


--
-- TOC entry 222 (class 1259 OID 30755)
-- Name: supplier; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mrp.supplier (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    phone character varying(50),
    mobile character varying(50),
    address character varying(100),
    city character varying(100),
    email character varying(50),
    org_id integer DEFAULT 1 NOT NULL,
    status boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    created_by integer,
    updated_by integer
);


--
-- TOC entry 221 (class 1259 OID 30754)
-- Name: supplier_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mrp.supplier_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5325 (class 0 OID 0)
-- Dependencies: 221
-- Name: supplier_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mrp.supplier_id_seq OWNED BY mrp.supplier.id;


--
-- TOC entry 230 (class 1259 OID 30849)
-- Name: supplier_item; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mrp.supplier_item (
    id integer NOT NULL,
    org_id integer DEFAULT 1 NOT NULL,
    product_id integer NOT NULL,
    supplier_id integer NOT NULL,
    price numeric(12,4),
    currency character varying(3),
    lead_time_days integer,
    min_order_qty numeric(12,4),
    pack_size numeric(12,4),
    is_preferred boolean DEFAULT false NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    CONSTRAINT ck_supplier_item_lead_time_nonneg CHECK ((lead_time_days >= 0)),
    CONSTRAINT ck_supplier_item_moq_nonneg CHECK ((min_order_qty >= (0)::numeric)),
    CONSTRAINT ck_supplier_item_price_nonneg CHECK ((price >= (0)::numeric))
);


--
-- TOC entry 229 (class 1259 OID 30848)
-- Name: supplier_item_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mrp.supplier_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5326 (class 0 OID 0)
-- Dependencies: 229
-- Name: supplier_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mrp.supplier_item_id_seq OWNED BY mrp.supplier_item.id;


--
-- TOC entry 251 (class 1259 OID 38707)
-- Name: system_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mrp.system_log (
    id integer NOT NULL,
    ts timestamp without time zone NOT NULL,
    user_id integer,
    org_id integer,
    action character varying(120),
    path text NOT NULL,
    method character varying(10) NOT NULL,
    ip character varying(64),
    status_code integer
);


--
-- TOC entry 250 (class 1259 OID 38706)
-- Name: system_log_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mrp.system_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5327 (class 0 OID 0)
-- Dependencies: 250
-- Name: system_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mrp.system_log_id_seq OWNED BY mrp.system_log.id;


--
-- TOC entry 220 (class 1259 OID 30721)
-- Name: unit; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mrp.unit (
    id integer NOT NULL,
    code character varying(50),
    description character varying(50)
);


--
-- TOC entry 219 (class 1259 OID 30720)
-- Name: unit_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mrp.unit_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5328 (class 0 OID 0)
-- Dependencies: 219
-- Name: unit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mrp.unit_id_seq OWNED BY mrp.unit.id;


--
-- TOC entry 232 (class 1259 OID 30935)
-- Name: user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mrp."user" (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    password character varying(255) NOT NULL,
    photo character varying(255),
    status boolean DEFAULT true
);


--
-- TOC entry 231 (class 1259 OID 30934)
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mrp.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5329 (class 0 OID 0)
-- Dependencies: 231
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mrp.user_id_seq OWNED BY mrp."user".id;


--
-- TOC entry 243 (class 1259 OID 31087)
-- Name: user_organization; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mrp.user_organization (
    user_id integer NOT NULL,
    org_id integer NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 237 (class 1259 OID 30965)
-- Name: user_role; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mrp.user_role (
    role_id integer NOT NULL,
    user_id integer NOT NULL
);


--
-- TOC entry 226 (class 1259 OID 30794)
-- Name: warehouse; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mrp.warehouse (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    location character varying(200),
    org_id integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- TOC entry 225 (class 1259 OID 30793)
-- Name: warehouse_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mrp.warehouse_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5330 (class 0 OID 0)
-- Dependencies: 225
-- Name: warehouse_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mrp.warehouse_id_seq OWNED BY mrp.warehouse.id;


--
-- TOC entry 265 (class 1259 OID 38855)
-- Name: work_order; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mrp.work_order (
    id integer NOT NULL,
    org_id integer NOT NULL,
    product_id integer NOT NULL,
    bom_id integer NOT NULL,
    quantity numeric(10,2) NOT NULL,
    status character varying(50) DEFAULT 'Planificada'::character varying NOT NULL,
    warehouse_id integer,
    assigned_to integer,
    reference character varying(100),
    notes text,
    planned_start timestamp without time zone,
    planned_end timestamp without time zone,
    actual_start timestamp without time zone,
    actual_end timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by integer,
    CONSTRAINT ck_work_order_quantity_positive CHECK ((quantity > (0)::numeric)),
    CONSTRAINT ck_work_order_status_valid CHECK (((status)::text = ANY ((ARRAY['Planificada'::character varying, 'En Progreso'::character varying, 'Finalizada'::character varying, 'Cancelada'::character varying])::text[])))
);


--
-- TOC entry 5331 (class 0 OID 0)
-- Dependencies: 265
-- Name: TABLE work_order; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE mrp.work_order IS 'Órdenes de Producción - Gestiona la fabricación de productos';


--
-- TOC entry 5332 (class 0 OID 0)
-- Dependencies: 265
-- Name: COLUMN work_order.bom_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN mrp.work_order.bom_id IS 'BOM utilizada para esta orden (snapshot al momento de creación)';


--
-- TOC entry 5333 (class 0 OID 0)
-- Dependencies: 265
-- Name: COLUMN work_order.quantity; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN mrp.work_order.quantity IS 'Cantidad a producir';


--
-- TOC entry 5334 (class 0 OID 0)
-- Dependencies: 265
-- Name: COLUMN work_order.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN mrp.work_order.status IS 'Estados: Planificada, En Progreso, Finalizada, Cancelada';


--
-- TOC entry 5335 (class 0 OID 0)
-- Dependencies: 265
-- Name: COLUMN work_order.reference; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN mrp.work_order.reference IS 'Referencia externa (orden de venta, cliente, etc)';


--
-- TOC entry 5336 (class 0 OID 0)
-- Dependencies: 265
-- Name: COLUMN work_order.actual_start; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN mrp.work_order.actual_start IS 'Fecha real de inicio (cuando pasa a En Progreso)';


--
-- TOC entry 5337 (class 0 OID 0)
-- Dependencies: 265
-- Name: COLUMN work_order.actual_end; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN mrp.work_order.actual_end IS 'Fecha real de finalización';


--
-- TOC entry 264 (class 1259 OID 38854)
-- Name: work_order_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mrp.work_order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5338 (class 0 OID 0)
-- Dependencies: 264
-- Name: work_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mrp.work_order_id_seq OWNED BY mrp.work_order.id;


--
-- TOC entry 4932 (class 2604 OID 38797)
-- Name: bom id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.bom ALTER COLUMN id SET DEFAULT nextval('mrp.bom_id_seq'::regclass);


--
-- TOC entry 4937 (class 2604 OID 38825)
-- Name: bom_component id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.bom_component ALTER COLUMN id SET DEFAULT nextval('mrp.bom_component_id_seq'::regclass);


--
-- TOC entry 4931 (class 2604 OID 38790)
-- Name: category categoryid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.category ALTER COLUMN categoryid SET DEFAULT nextval('mrp.category_categoryid_seq'::regclass);


--
-- TOC entry 4912 (class 2604 OID 38656)
-- Name: drawer drawerid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.drawer ALTER COLUMN drawerid SET DEFAULT nextval('mrp.drawer_drawerid_seq'::regclass);


--
-- TOC entry 4907 (class 2604 OID 31013)
-- Name: movement id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.movement ALTER COLUMN id SET DEFAULT nextval('mrp.movement_id_seq'::regclass);


--
-- TOC entry 4929 (class 2604 OID 38770)
-- Name: org_subscription id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.org_subscription ALTER COLUMN id SET DEFAULT nextval('mrp.org_subscription_id_seq'::regclass);


--
-- TOC entry 4879 (class 2604 OID 30714)
-- Name: organization id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.organization ALTER COLUMN id SET DEFAULT nextval('mrp.organization_id_seq'::regclass);


--
-- TOC entry 4915 (class 2604 OID 38691)
-- Name: plan id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.plan ALTER COLUMN id SET DEFAULT nextval('mrp.plan_id_seq'::regclass);


--
-- TOC entry 4885 (class 2604 OID 30772)
-- Name: product id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.product ALTER COLUMN id SET DEFAULT nextval('mrp.product_id_seq'::regclass);


--
-- TOC entry 4895 (class 2604 OID 30830)
-- Name: product_warehouse id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.product_warehouse ALTER COLUMN id SET DEFAULT nextval('mrp.product_warehouse_id_seq'::regclass);


--
-- TOC entry 4913 (class 2604 OID 38663)
-- Name: purchase id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.purchase ALTER COLUMN id SET DEFAULT nextval('mrp.purchase_id_seq'::regclass);


--
-- TOC entry 4928 (class 2604 OID 38753)
-- Name: purchase_detail id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.purchase_detail ALTER COLUMN id SET DEFAULT nextval('mrp.purchase_detail_id_seq'::regclass);


--
-- TOC entry 4927 (class 2604 OID 38732)
-- Name: report_audit id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.report_audit ALTER COLUMN id SET DEFAULT nextval('mrp.report_audit_id_seq'::regclass);


--
-- TOC entry 4905 (class 2604 OID 30962)
-- Name: resource id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.resource ALTER COLUMN id SET DEFAULT nextval('mrp.resource_id_seq'::regclass);


--
-- TOC entry 4903 (class 2604 OID 30950)
-- Name: role id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.role ALTER COLUMN id SET DEFAULT nextval('mrp.role_id_seq'::regclass);


--
-- TOC entry 4906 (class 2604 OID 30984)
-- Name: subresource id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.subresource ALTER COLUMN id SET DEFAULT nextval('mrp.subresource_id_seq'::regclass);


--
-- TOC entry 4882 (class 2604 OID 30758)
-- Name: supplier id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.supplier ALTER COLUMN id SET DEFAULT nextval('mrp.supplier_id_seq'::regclass);


--
-- TOC entry 4897 (class 2604 OID 30852)
-- Name: supplier_item id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.supplier_item ALTER COLUMN id SET DEFAULT nextval('mrp.supplier_item_id_seq'::regclass);


--
-- TOC entry 4926 (class 2604 OID 38710)
-- Name: system_log id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.system_log ALTER COLUMN id SET DEFAULT nextval('mrp.system_log_id_seq'::regclass);


--
-- TOC entry 4881 (class 2604 OID 30724)
-- Name: unit id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.unit ALTER COLUMN id SET DEFAULT nextval('mrp.unit_id_seq'::regclass);


--
-- TOC entry 4901 (class 2604 OID 30938)
-- Name: user id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp."user" ALTER COLUMN id SET DEFAULT nextval('mrp.user_id_seq'::regclass);


--
-- TOC entry 4893 (class 2604 OID 30797)
-- Name: warehouse id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.warehouse ALTER COLUMN id SET DEFAULT nextval('mrp.warehouse_id_seq'::regclass);


--
-- TOC entry 4941 (class 2604 OID 38858)
-- Name: work_order id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.work_order ALTER COLUMN id SET DEFAULT nextval('mrp.work_order_id_seq'::regclass);


--
-- TOC entry 5290 (class 0 OID 38794)
-- Dependencies: 261
-- Data for Name: bom; Type: TABLE DATA; Schema: public; Owner: -
--

COPY mrp.bom (id, org_id, product_id, version, is_active, description, created_at, updated_at) FROM stdin;
1	1	124	1.0	t	Válvula check bronce con asiento	2025-11-07 09:37:25.986988	2025-11-07 09:37:25.986988
2	1	125	1.0	t	Válvula de bola latón paso total	2025-11-07 09:37:26.016904	2025-11-07 09:37:26.016904
3	1	127	1.0	t	Bomba centrífuga con motor monofásico	2025-11-07 09:37:26.020564	2025-11-07 09:37:26.020564
4	1	129	1.0	t	Panel control eléctrico con PLC	2025-11-07 09:37:26.036822	2025-11-07 09:37:26.036822
5	1	131	1.0	t	Ventilador axial industrial 24 pulgadas	2025-11-07 09:37:26.047853	2025-11-07 09:37:26.047853
6	1	133	1.0	t	Reductor velocidad relación 1:40	2025-11-07 09:37:26.063714	2025-11-07 09:37:26.063714
7	1	130	1.0	t	Caja distribución eléctrica residencial	2025-11-07 09:37:26.079564	2025-11-07 09:37:26.079564
8	1	132	1.0	t	Extractor axial para baño/cocina	2025-11-07 09:37:26.086856	2025-11-07 09:37:26.086856
9	1	136	1.0	t	Compresor portátil 6L sin aceite	2025-11-07 09:37:26.096874	2025-11-07 09:37:26.096874
10	1	134	1.0	t	Filtro agua con cartucho 10 pulgadas	2025-11-07 09:37:26.10676	2025-11-07 09:37:26.10676
\.


--
-- TOC entry 5292 (class 0 OID 38822)
-- Dependencies: 263
-- Data for Name: bom_component; Type: TABLE DATA; Schema: public; Owner: -
--

COPY mrp.bom_component (id, bom_id, component_id, quantity, scrap_percentage, unit_id, sequence, notes, created_at) FROM stdin;
1	1	6	0.3000	5.00	2	1	Cuerpo bronce	2025-11-07 09:37:26.005651
2	1	89	4.0000	2.00	1	2	Fijación tapa	2025-11-07 09:37:26.005651
3	2	7	0.4000	4.00	2	1	Cuerpo y bola latón	2025-11-07 09:37:26.020564
4	3	31	1.0000	0.00	1	1	Motor eléctrico	2025-11-07 09:37:26.032606
5	3	4	3.5000	8.00	2	2	Carcasa fundida	2025-11-07 09:37:26.032606
6	3	61	2.0000	0.00	1	3	Rodamientos eje	2025-11-07 09:37:26.036822
7	3	66	1.0000	0.00	1	4	Sello mecánico	2025-11-07 09:37:26.036822
8	3	90	12.0000	2.00	1	5	Ensamble	2025-11-07 09:37:26.036822
9	4	48	1.0000	0.00	1	1	Gabinete metálico	2025-11-07 09:37:26.047853
10	4	58	1.0000	0.00	1	2	PLC Siemens	2025-11-07 09:37:26.047853
11	4	38	3.0000	0.00	1	3	Contactores potencia	2025-11-07 09:37:26.047853
12	4	50	2.0000	0.00	1	4	Pulsadores marcha	2025-11-07 09:37:26.047853
13	4	51	1.0000	0.00	1	5	Pulsador paro emergencia	2025-11-07 09:37:26.047853
14	4	46	50.0000	10.00	3	6	Cableado interno	2025-11-07 09:37:26.047853
15	5	32	1.0000	0.00	1	1	Motor ventilador	2025-11-07 09:37:26.056875
16	5	3	15.0000	5.00	2	2	Hélice y carcasa	2025-11-07 09:37:26.056875
17	5	62	2.0000	0.00	1	3	Rodamientos soporte	2025-11-07 09:37:26.056875
18	6	2	25.0000	3.00	2	1	Carcasa fundida	2025-11-07 09:37:26.073541
19	6	78	4.0000	0.00	1	2	Tren de engranajes	2025-11-07 09:37:26.073541
20	6	63	4.0000	0.00	1	3	Rodamientos ejes	2025-11-07 09:37:26.073541
21	6	118	2.0000	0.00	1	4	Aceite lubricante	2025-11-07 09:37:26.073541
22	7	12	1.5000	5.00	2	1	Caja plástica moldeada	2025-11-07 09:37:26.083878
23	7	42	6.0000	0.00	1	2	Breakers monopolares	2025-11-07 09:37:26.083878
24	8	31	1.0000	0.00	1	1	Motor extractor	2025-11-07 09:37:26.093352
25	8	10	0.8000	8.00	2	2	Hélice y carcasa plástica	2025-11-07 09:37:26.093352
26	9	31	1.0000	0.00	1	1	Motor compresor	2025-11-07 09:37:26.09893
27	9	3	3.0000	4.00	2	2	Tanque 6L	2025-11-07 09:37:26.09893
28	9	84	1.0000	0.00	1	3	Manómetro presión	2025-11-07 09:37:26.09893
29	10	11	0.5000	5.00	2	1	Carcasa plástica	2025-11-07 09:37:26.110674
\.


--
-- TOC entry 5288 (class 0 OID 38787)
-- Dependencies: 259
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: -
--

COPY mrp.category (categoryid, code, name, description, created_at, updated_at, deleted_at, created_by, updated_by, status, folder, companyid_by) FROM stdin;
\.


--
-- TOC entry 5274 (class 0 OID 38653)
-- Dependencies: 245
-- Data for Name: drawer; Type: TABLE DATA; Schema: public; Owner: -
--

COPY mrp.drawer (drawerid, drawercode, cantdivisiones, cantdivlibres) FROM stdin;
\.


--
-- TOC entry 5270 (class 0 OID 31010)
-- Dependencies: 241
-- Data for Name: movement; Type: TABLE DATA; Schema: public; Owner: -
--

COPY mrp.movement (id, org_id, product_id, from_warehouse_id, to_warehouse_id, movement_type, reason, quantity, reference_id, reference_type, note, created_by, created_at) FROM stdin;
1	1	1	\N	1	IN	PURCHASE	75.000000	PO-2025-001	PO	Compra proveedor - Lote 1	1	2025-11-01 09:37:26.173024
2	1	2	\N	2	IN	PURCHASE	23.000000	PO-2025-002	PO	Compra proveedor - Lote 2	4	2025-11-04 09:37:26.173024
3	1	3	\N	3	IN	PURCHASE	81.000000	PO-2025-003	PO	Compra proveedor - Lote 3	5	2025-10-25 09:37:26.173024
4	1	4	\N	4	IN	PURCHASE	87.000000	PO-2025-004	PO	Compra proveedor - Lote 4	1	2025-10-12 09:37:26.173024
5	1	5	\N	5	IN	PURCHASE	36.000000	PO-2025-005	PO	Compra proveedor - Lote 5	4	2025-10-14 09:37:26.173024
6	1	6	\N	1	IN	PURCHASE	92.000000	PO-2025-006	PO	Compra proveedor - Lote 6	5	2025-11-04 09:37:26.173024
7	1	7	\N	2	IN	PURCHASE	60.000000	PO-2025-007	PO	Compra proveedor - Lote 7	1	2025-10-21 09:37:26.173024
8	1	8	\N	3	IN	PURCHASE	45.000000	PO-2025-008	PO	Compra proveedor - Lote 8	4	2025-10-21 09:37:26.173024
9	1	9	\N	4	IN	PURCHASE	71.000000	PO-2025-009	PO	Compra proveedor - Lote 9	5	2025-10-26 09:37:26.173024
10	1	10	\N	5	IN	PURCHASE	25.000000	PO-2025-010	PO	Compra proveedor - Lote 10	1	2025-10-27 09:37:26.173024
11	1	11	\N	1	IN	PURCHASE	13.000000	PO-2025-011	PO	Compra proveedor - Lote 11	4	2025-10-13 09:37:26.173024
12	1	12	\N	2	IN	PURCHASE	47.000000	PO-2025-012	PO	Compra proveedor - Lote 12	5	2025-10-22 09:37:26.173024
13	1	13	\N	3	IN	PURCHASE	51.000000	PO-2025-013	PO	Compra proveedor - Lote 13	1	2025-11-04 09:37:26.173024
14	1	14	\N	4	IN	PURCHASE	50.000000	PO-2025-014	PO	Compra proveedor - Lote 14	4	2025-11-05 09:37:26.173024
15	1	15	\N	5	IN	PURCHASE	77.000000	PO-2025-015	PO	Compra proveedor - Lote 15	5	2025-10-13 09:37:26.173024
16	1	16	\N	1	IN	PURCHASE	67.000000	PO-2025-016	PO	Compra proveedor - Lote 16	1	2025-11-04 09:37:26.173024
17	1	17	\N	2	IN	PURCHASE	92.000000	PO-2025-017	PO	Compra proveedor - Lote 17	4	2025-11-03 09:37:26.173024
18	1	18	\N	3	IN	PURCHASE	92.000000	PO-2025-018	PO	Compra proveedor - Lote 18	5	2025-11-01 09:37:26.173024
19	1	19	\N	4	IN	PURCHASE	40.000000	PO-2025-019	PO	Compra proveedor - Lote 19	1	2025-10-30 09:37:26.173024
20	1	20	\N	5	IN	PURCHASE	67.000000	PO-2025-020	PO	Compra proveedor - Lote 20	4	2025-11-01 09:37:26.173024
21	1	1	3	\N	OUT	CONSUMPTION	40.000000	1	WO	Consumo para WO-2025-001	1	2025-10-30 09:37:26.173024
22	1	2	4	\N	OUT	CONSUMPTION	49.000000	2	WO	Consumo para WO-2025-002	4	2025-11-06 09:37:26.173024
23	1	3	3	\N	OUT	CONSUMPTION	44.000000	3	WO	Consumo para WO-2025-003	5	2025-10-31 09:37:26.173024
24	1	4	4	\N	OUT	CONSUMPTION	13.000000	4	WO	Consumo para WO-2025-004	1	2025-11-05 09:37:26.173024
25	1	5	3	\N	OUT	CONSUMPTION	44.000000	5	WO	Consumo para WO-2025-005	4	2025-11-05 09:37:26.173024
26	1	6	4	\N	OUT	CONSUMPTION	26.000000	6	WO	Consumo para WO-2025-006	5	2025-10-29 09:37:26.173024
27	1	7	3	\N	OUT	CONSUMPTION	26.000000	7	WO	Consumo para WO-2025-007	1	2025-11-03 09:37:26.173024
28	1	8	4	\N	OUT	CONSUMPTION	26.000000	8	WO	Consumo para WO-2025-008	4	2025-10-30 09:37:26.173024
29	1	9	3	\N	OUT	CONSUMPTION	30.000000	9	WO	Consumo para WO-2025-009	5	2025-10-28 09:37:26.173024
30	1	10	4	\N	OUT	CONSUMPTION	27.000000	10	WO	Consumo para WO-2025-010	1	2025-11-06 09:37:26.173024
31	1	11	3	\N	OUT	CONSUMPTION	11.000000	11	WO	Consumo para WO-2025-011	4	2025-10-28 09:37:26.173024
32	1	12	4	\N	OUT	CONSUMPTION	32.000000	12	WO	Consumo para WO-2025-012	5	2025-10-31 09:37:26.173024
33	1	13	3	\N	OUT	CONSUMPTION	36.000000	13	WO	Consumo para WO-2025-013	1	2025-11-06 09:37:26.173024
34	1	14	4	\N	OUT	CONSUMPTION	10.000000	14	WO	Consumo para WO-2025-014	4	2025-10-28 09:37:26.173024
35	1	15	3	\N	OUT	CONSUMPTION	20.000000	15	WO	Consumo para WO-2025-015	5	2025-10-31 09:37:26.173024
36	1	83	\N	1	IN	PRODUCTION	20.000000	1	WO	Producción WO-2025-001 completada	1	2025-11-01 09:37:26.173024
37	1	124	\N	1	IN	PRODUCTION	17.000000	2	WO	Producción WO-2025-002 completada	4	2025-11-03 09:37:26.173024
38	1	125	\N	1	IN	PRODUCTION	16.000000	3	WO	Producción WO-2025-003 completada	5	2025-11-04 09:37:26.173024
39	1	126	\N	1	IN	PRODUCTION	14.000000	4	WO	Producción WO-2025-004 completada	1	2025-11-06 09:37:26.173024
40	1	127	\N	1	IN	PRODUCTION	23.000000	5	WO	Producción WO-2025-005 completada	4	2025-11-01 09:37:26.173024
41	1	128	\N	1	IN	PRODUCTION	25.000000	6	WO	Producción WO-2025-006 completada	5	2025-11-06 09:37:26.173024
42	1	129	\N	1	IN	PRODUCTION	23.000000	7	WO	Producción WO-2025-007 completada	1	2025-11-01 09:37:26.173024
43	1	130	\N	1	IN	PRODUCTION	11.000000	8	WO	Producción WO-2025-008 completada	4	2025-11-01 09:37:26.173024
44	1	131	\N	1	IN	PRODUCTION	13.000000	9	WO	Producción WO-2025-009 completada	5	2025-11-01 09:37:26.173024
45	1	1	1	2	TRANSFER	TRANSFER	77.000000	TRANS-001	TRANSFER	Transferencia de Almacén Central a Almacén Norte	1	2025-11-02 09:37:26.173024
46	1	4	2	3	TRANSFER	TRANSFER	92.000000	TRANS-002	TRANSFER	Transferencia de Almacén Norte a Almacén de Materia Prima	4	2025-10-31 09:37:26.173024
47	1	7	3	4	TRANSFER	TRANSFER	83.000000	TRANS-003	TRANSFER	Transferencia de Almacén de Materia Prima a Almacén de Producto Terminado	5	2025-10-26 09:37:26.173024
48	1	10	4	5	TRANSFER	TRANSFER	34.000000	TRANS-004	TRANSFER	Transferencia de Almacén de Producto Terminado a Almacén de Consumibles	1	2025-10-31 09:37:26.173024
49	1	13	5	1	TRANSFER	TRANSFER	63.000000	TRANS-005	TRANSFER	Transferencia de Almacén de Consumibles a Almacén Central	4	2025-10-26 09:37:26.173024
50	1	16	1	2	TRANSFER	TRANSFER	51.000000	TRANS-006	TRANSFER	Transferencia de Almacén Central a Almacén Norte	5	2025-11-04 09:37:26.173024
51	1	19	2	3	TRANSFER	TRANSFER	40.000000	TRANS-007	TRANSFER	Transferencia de Almacén Norte a Almacén de Materia Prima	1	2025-11-06 09:37:26.173024
52	1	22	3	4	TRANSFER	TRANSFER	93.000000	TRANS-008	TRANSFER	Transferencia de Almacén de Materia Prima a Almacén de Producto Terminado	4	2025-10-25 09:37:26.173024
53	1	25	4	5	TRANSFER	TRANSFER	43.000000	TRANS-009	TRANSFER	Transferencia de Almacén de Producto Terminado a Almacén de Consumibles	5	2025-11-04 09:37:26.173024
54	1	28	5	1	TRANSFER	TRANSFER	51.000000	TRANS-010	TRANSFER	Transferencia de Almacén de Consumibles a Almacén Central	1	2025-11-06 09:37:26.173024
55	1	1	\N	1	ADJUST	ADJUSTMENT	7.000000	ADJ-001	ADJ	Ajuste por inventario físico - Diferencia detectada	1	2025-11-04 09:37:26.173024
56	1	6	\N	2	ADJUST	ADJUSTMENT	4.000000	ADJ-002	ADJ	Ajuste por inventario físico - Diferencia detectada	4	2025-11-02 09:37:26.173024
57	1	11	\N	3	ADJUST	ADJUSTMENT	6.000000	ADJ-003	ADJ	Ajuste por inventario físico - Diferencia detectada	5	2025-11-03 09:37:26.173024
58	1	16	\N	4	ADJUST	ADJUSTMENT	18.000000	ADJ-004	ADJ	Ajuste por inventario físico - Diferencia detectada	1	2025-11-03 09:37:26.173024
59	1	21	\N	5	ADJUST	ADJUSTMENT	5.000000	ADJ-005	ADJ	Ajuste por inventario físico - Diferencia detectada	4	2025-11-06 09:37:26.173024
60	1	1	\N	1	IN	RETURN	15.000000	DEV-001	RETURN	Devolución de material no utilizado	1	2025-11-01 09:37:26.173024
61	1	8	\N	2	IN	RETURN	8.000000	DEV-002	RETURN	Devolución de material no utilizado	4	2025-11-01 09:37:26.173024
62	1	15	\N	3	IN	RETURN	5.000000	DEV-003	RETURN	Devolución de material no utilizado	5	2025-11-01 09:37:26.173024
63	1	22	\N	4	IN	RETURN	9.000000	DEV-004	RETURN	Devolución de material no utilizado	1	2025-10-28 09:37:26.173024
64	1	29	\N	5	IN	RETURN	13.000000	DEV-005	RETURN	Devolución de material no utilizado	4	2025-11-04 09:37:26.173024
\.


--
-- TOC entry 5286 (class 0 OID 38767)
-- Dependencies: 257
-- Data for Name: org_subscription; Type: TABLE DATA; Schema: public; Owner: -
--

COPY mrp.org_subscription (id, org_id, plan_id, status, started_at, trial_until, max_users_override, max_products_override, max_warehouses_override, max_movements_per_day_override) FROM stdin;
1	3	1	active	2025-10-24 18:10:45.095	2025-11-07 18:10:45.082348	\N	\N	\N	\N
2	1	1	active	2025-10-24 20:51:28.153393	2025-11-07 20:51:28.15131	\N	\N	\N	\N
3	2	1	active	2025-10-24 20:51:28.160422	2025-11-07 20:51:28.159513	\N	\N	\N	\N
\.


--
-- TOC entry 5247 (class 0 OID 30711)
-- Dependencies: 218
-- Data for Name: organization; Type: TABLE DATA; Schema: public; Owner: -
--

COPY mrp.organization (id, name, code, is_active) FROM stdin;
1	Acme S.A.	ACME	t
2	Globex Ltd.	GLOBEX	t
3	TestCompany_712	TST772	t
\.


--
-- TOC entry 5278 (class 0 OID 38688)
-- Dependencies: 249
-- Data for Name: plan; Type: TABLE DATA; Schema: public; Owner: -
--

COPY mrp.plan (id, code, name, is_active, max_users, max_products, max_warehouses, max_movements_per_day, max_ai_reports_per_day, allow_bom, allow_work_orders, allow_mrp, allow_forecast) FROM stdin;
1	free	Free	t	3	50	1	50	10	f	f	f	f
2	starter	Starter	t	10	500	3	500	100	f	f	f	f
3	pro	Pro	t	99999	99999	99999	99999	500	t	t	t	t
\.


--
-- TOC entry 5253 (class 0 OID 30769)
-- Dependencies: 224
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: -
--

COPY mrp.product (id, org_id, code, name, description, unit_id, min_stock, procurement_type, item_type, status, created_at, updated_at) FROM stdin;
1	1	ACER-304	Acero Inoxidable 304	Lámina de acero inoxidable 1.5mm	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
2	1	ACER-1020	Acero Carbono 1020	Barra redonda acero al carbono 1 pulgada	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
3	1	ACER-GALV	Acero Galvanizado	Lámina galvanizada calibre 18	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
4	1	ALU-6061	Aluminio 6061	Barra de aluminio extruido	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
5	1	ALU-7075	Aluminio 7075	Placa de aluminio aeronáutico	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
6	1	BRON-40	Bronce SAE 40	Barra de bronce fosforado	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
7	1	LAT-6040	Latón 60/40	Tubo de latón 3/4 pulgada	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
8	1	COB-C110	Cobre C110	Cable de cobre calibre 12	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
9	1	COB-ELEC	Cobre Electrolítico	Barra de cobre puro 99.9%	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
10	1	PLAS-ABS	Plástico ABS	Gránulos de plástico ABS	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
11	1	PLAS-HDPE	Plástico HDPE	Polietileno alta densidad natural	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
12	1	PLAS-PVC	Plástico PVC	PVC rígido en polvo	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
13	1	NYL-6	Nylon 6	Barras de nylon 6 natural	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
14	1	TEFL-PTFE	Teflón PTFE	Placa de teflón blanco	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
15	1	CAU-NIT	Caucho Nitrilo	Lámina de caucho nitrilo	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
16	1	SIL-IND	Silicona Industrial	Silicona líquida RTV	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
17	1	PVC-RIG	PVC Rígido	Tubería PVC presión 1/2 pulgada	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
18	1	FIB-VID	Fibra de Vidrio	Tela de fibra de vidrio	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
19	1	RES-EPO	Resina Epoxi	Resina epoxi bicomponente	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
20	1	MAD-PINO	Madera Pino	Tablón de pino 2x4 pulgadas	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
21	1	MDF-15	MDF 15mm	Plancha MDF 15mm	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
22	1	TRIP-12	Triplay 12mm	Plancha triplay 12mm	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
23	1	VID-TEMP	Vidrio Templado	Vidrio templado 6mm	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
24	1	PINT-EPO	Pintura Epóxica	Pintura epóxica industrial galón	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
25	1	THIN-ACR	Thinner Acrílico	Diluyente acrílico galón	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
26	1	CEM-GRIS	Cemento Gris	Cemento portland 50kg	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
27	1	AREN-FIN	Arena Fina	Arena fina lavada m³	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
28	1	GRAV-34	Grava 3/4	Grava chancada 3/4 pulgada	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
29	1	CAL-HID	Cal Hidratada	Cal hidratada 25kg	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
30	1	YES-BLAN	Yeso Blanco	Yeso blanco bolsa 25kg	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
31	1	MOT-1HP	Motor Eléctrico 1HP	Motor monofásico 1HP 110V	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
32	1	MOT-3HP	Motor Eléctrico 3HP	Motor trifásico 3HP 220V	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
33	1	MOT-5HP	Motor Eléctrico 5HP	Motor trifásico 5HP 440V	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
34	1	MOT-10HP	Motor Eléctrico 10HP	Motor trifásico 10HP 440V	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
35	1	TRANS-500	Transformador 500VA	Transformador 220/110V 500VA	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
36	1	TRANS-1K	Transformador 1KVA	Transformador trifásico 1KVA	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
37	1	TRANS-5K	Transformador 5KVA	Transformador trifásico 5KVA	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
38	1	CONT-25A	Contactor 25A	Contactor tripolar 25A	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
39	1	CONT-40A	Contactor 40A	Contactor tripolar 40A	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
40	1	RELE-10A	Relé Térmico 10A	Relé térmico 7-10A	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
41	1	RELE-25A	Relé Térmico 25A	Relé térmico 18-25A	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
42	1	ITM-20A	Interruptor Termomagnético 20A	Breaker 1P 20A	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
43	1	ITM-50A	Interruptor Termomagnético 50A	Breaker 3P 50A	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
44	1	ITM-100A	Interruptor Termomagnético 100A	Breaker 3P 100A	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
45	1	CAB-NYY-10	Cable NYY 3x10	Cable NYY 3x10mm²	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
46	1	CAB-THW-12	Cable THW 12 AWG	Cable THW calibre 12	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
47	1	CAB-THW-8	Cable THW 8 AWG	Cable THW calibre 8	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
48	1	TAB-24P	Tablero Eléctrico 24 Polos	Tablero embutir 24 módulos	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
49	1	TAB-36P	Tablero Eléctrico 36 Polos	Tablero embutir 36 módulos	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
50	1	PULS-VER	Pulsador Verde	Pulsador NA verde	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
51	1	PULS-ROJO	Pulsador Rojo	Pulsador NC rojo seta	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
52	1	LAMP-AMA	Lámpara Piloto Amarilla	Luz piloto amarilla LED	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
53	1	LAMP-ROJA	Lámpara Piloto Roja	Luz piloto roja LED	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
54	1	SENS-IND	Sensor Inductivo	Sensor proximidad inductivo NPN	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
55	1	SENS-CAP	Sensor Capacitivo	Sensor capacitivo PNP	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
56	1	FOTO-IR	Fotosensor Infrarrojo	Fotocélula infrarroja	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
57	1	RELE-TMP	Relé Temporizador	Relé retardo 0-60s	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
58	1	PLC-S7	PLC S7-200	PLC Siemens S7-200 CPU 224	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
59	1	VFD-2HP	Variador Frecuencia 2HP	Variador velocidad 2HP 220V	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
60	1	ELEC-VAL	Electroválvula 1/2"	Electroválvula solenoide 1/2 pulgada	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
61	1	ROD-6204	Rodamiento 6204	Rodamiento de bolas 6204-2RS	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
62	1	ROD-6205	Rodamiento 6205	Rodamiento de bolas 6205-2RS	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
63	1	ROD-6206	Rodamiento 6206	Rodamiento de bolas 6206-2RS	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
64	1	ROD-6207	Rodamiento 6207	Rodamiento de bolas 6207-2RS	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
65	1	ROD-CON	Rodamiento Cónico	Rodamiento cónico 30205	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
66	1	RET-2540	Retenedor 25x40	Retenedor labio 25x40x7	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
67	1	RET-3047	Retenedor 30x47	Retenedor labio 30x47x7	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
68	1	CHAV-6	Chaveta 6x6x20	Chaveta cuadrada 6x6x20mm	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
69	1	CHAV-8	Chaveta 8x7x25	Chaveta cuadrada 8x7x25mm	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
70	1	EJE-25	Eje Acero 25mm	Eje acero calibrado 25mm x 1m	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
71	1	EJE-30	Eje Acero 30mm	Eje acero calibrado 30mm x 1m	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
72	1	POL-A3	Polea Tipo A 3"	Polea trapecial tipo A 3 pulgadas	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
73	1	POL-B6	Polea Tipo B 6"	Polea trapecial tipo B 6 pulgadas	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
74	1	COR-A48	Correa Tipo A48	Correa trapecial A48	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
75	1	COR-B60	Correa Tipo B60	Correa trapecial B60	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
76	1	CAD-40	Cadena 40-1	Cadena transmisión 40-1	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
77	1	PIN-4020	Piñón 40-20T	Piñón cadena 40 paso 20 dientes	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
78	1	ENG-Z20	Engranaje Recto Z20	Engranaje recto módulo 2 Z20	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
79	1	RES-COMP	Resorte Compresión	Resorte de compresión 50mm	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
80	1	RES-TRAC	Resorte Tracción	Resorte de tracción 40mm	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
81	1	AMOR-NEU	Amortiguador Neumático	Amortiguador neumático ajustable	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
82	1	CIL-50	Cilindro Neumático 50mm	Cilindro doble efecto 50mm stroke	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
83	1	VAL-52	Válvula Neumática 5/2	Válvula 5/2 vías piloto neumático	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
84	1	MAN-10B	Manómetro 0-10bar	Manómetro glicerina 0-10bar	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
85	1	RAC-14	Racor Rápido 1/4"	Racor rápido neumático 1/4 pulgada	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
86	1	MANG-NEU	Manguera Neumática	Manguera poliuretano 6mm	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
87	1	FILT-REG	Filtro Regulador	Unidad FRL 1/4 pulgada	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
88	1	SIL-NEU	Silenciador Neumático	Silenciador escape 1/8 pulgada	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
89	1	TOR-M6-20	Tornillo M6x20	Tornillo hexagonal M6x20 acero	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
90	1	TOR-M8-50	Tornillo M8x50	Tornillo hexagonal M8x50 acero	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
91	1	TOR-M10-60	Tornillo M10x60	Tornillo hexagonal M10x60 acero	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
92	1	TOR-M12-80	Tornillo M12x80	Tornillo hexagonal M12x80 acero	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
93	1	ARN-M6	Arandela M6	Arandela plana M6 zincada	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
94	1	ARN-M8	Arandela M8	Arandela plana M8 zincada	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
95	1	ARN-M10	Arandela M10	Arandela plana M10 zincada	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
96	1	ARP-M8	Arandela Presión M8	Arandela presión M8	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
97	1	TUE-M8	Tuerca M8	Tuerca hexagonal M8	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
98	1	TUE-M10	Tuerca M10	Tuerca hexagonal M10	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
99	1	PERN-ANC	Perno Anclaje	Perno expansión 3/8x3 pulgadas	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
100	1	REM-4	Remache Pop 4mm	Remache pop aluminio 4mm	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
101	1	GRAP-OME	Grapa Omega	Grapa omega para tubería	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
102	1	ABRAZ-2	Abrazadera 2"	Abrazadera tipo gusano 2 pulgadas	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
103	1	PRIS-M6	Prisionero M6	Tornillo prisionero M6x10 punta copa	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
104	1	TAL-IND	Taladro Industrial	Taladro de banco 1/2 pulgada	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
105	1	AMOL-7	Amoladora 7"	Amoladora angular 7 pulgadas 2000W	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
106	1	SIER-CIR	Sierra Circular	Sierra circular 7 1/4 pulgadas	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
107	1	SOLD-INV	Soldadora Inverter	Soldadora inverter 200A	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
108	1	LLA-12	Llave Inglesa 12"	Llave ajustable 12 pulgadas	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
109	1	DES-SET	Destornillador Set	Set de destornilladores 6 piezas	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
110	1	CAL-DIG	Calibrador Digital	Calibrador vernier digital 6 pulgadas	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
111	1	MIC-25	Micrómetro 0-25mm	Micrómetro exterior 0-25mm	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
112	1	PREN-6	Prensa Banco 6"	Prensa tornillo banco 6 pulgadas	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
113	1	COMP-50L	Compresor 50L	Compresor aire 2HP tanque 50L	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
114	1	SOL-EST	Soldadura Estaño	Soldadura estaño-plomo 60/40	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
115	1	ELEC-332	Electrodo 3/32	Electrodo 6013 3/32 pulgada	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
116	1	DISC-MET	Disco Corte Metal 7"	Disco corte metal 7 pulgadas	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
117	1	DISC-DES	Disco Desbaste 7"	Disco desbaste 7 pulgadas	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
118	1	ACE-LUB	Aceite Lubricante	Aceite lubricante industrial 1L	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
119	1	GRAS-MUL	Grasa Multiuso	Grasa litio multiuso 500g	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
120	1	LIJ-120	Lija Grano 120	Lija de papel grano 120	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
121	1	CIN-AIS	Cinta Aislante	Cinta aislante negra 20m	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
122	1	GUA-NIT	Guantes Nitrilo	Guantes nitrilo talla M (caja 100)	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
123	1	GUA-CUER	Guantes Cuero	Guantes carnaza soldador	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
124	1	VAL-CHK-12	Válvula Check 1/2"	Válvula check bronce 1/2 pulgada	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
125	1	VAL-BOL-34	Válvula Bola 3/4"	Válvula bola latón 3/4 pulgada	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
126	1	VAL-MAR-2	Válvula Mariposa 2"	Válvula mariposa hierro 2 pulgadas	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
127	1	BOM-CEN-1	Bomba Centrífuga 1HP	Bomba centrífuga 1HP monofásica	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
128	1	BOM-PER	Bomba Periférica 0.5HP	Bomba periférica 0.5HP	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
129	1	PAN-CTL	Panel de Control	Panel de control eléctrico 220V	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
130	1	CAJ-DIS	Caja Distribución	Caja distribución eléctrica 12 módulos	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
131	1	VEN-IND	Ventilador Industrial	Ventilador industrial 24 pulgadas	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
132	1	EXT-AIRE	Extractor Aire	Extractor axial 12 pulgadas	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
133	1	RED-VEL	Reductor Velocidad	Reductor velocidad 1:40	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
134	1	FILT-AG	Filtro Agua 10"	Filtro agua cartucho 10 pulgadas	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
135	1	TANQ-HID	Tanque Hidroneumático	Tanque hidroneumático 24L	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
136	1	COMP-PORT	Compresor Portátil	Compresor portátil 6L sin aceite	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
137	1	ESM-BANC	Esmeril Banco	Esmeril de banco 6 pulgadas	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
138	1	HIDR-LAV	Hidrolavadora	Hidrolavadora 1800PSI	\N	10.00	BUY	FG	t	2025-11-07 09:37:25.776796	2025-11-07 09:37:25.776796
\.


--
-- TOC entry 5257 (class 0 OID 30827)
-- Dependencies: 228
-- Data for Name: product_warehouse; Type: TABLE DATA; Schema: public; Owner: -
--

COPY mrp.product_warehouse (id, productid, warehouseid, stock) FROM stdin;
1	1	1	50.00
2	1	2	70.00
3	2	1	50.00
4	2	2	70.00
5	2	3	90.00
6	3	1	50.00
7	3	2	70.00
8	3	3	90.00
9	4	1	50.00
10	4	2	70.00
11	5	1	50.00
12	5	2	70.00
13	5	3	90.00
14	6	1	50.00
15	6	2	70.00
16	6	3	90.00
17	7	1	50.00
18	7	2	70.00
19	8	1	50.00
20	8	2	70.00
21	8	3	90.00
22	9	1	50.00
23	9	2	70.00
24	9	3	90.00
25	10	1	50.00
26	10	2	70.00
27	11	1	50.00
28	11	2	70.00
29	11	3	90.00
30	12	1	50.00
31	12	2	70.00
32	12	3	90.00
33	13	1	50.00
34	13	2	70.00
35	14	1	50.00
36	14	2	70.00
37	14	3	90.00
38	15	1	50.00
39	15	2	70.00
40	15	3	90.00
41	16	1	50.00
42	16	2	70.00
43	17	1	50.00
44	17	2	70.00
45	17	3	90.00
46	18	1	50.00
47	18	2	70.00
48	18	3	90.00
49	19	1	50.00
50	19	2	70.00
51	20	1	50.00
52	20	2	70.00
53	20	3	90.00
54	21	1	50.00
55	21	2	70.00
56	21	3	90.00
57	22	1	50.00
58	22	2	70.00
59	23	1	50.00
60	23	2	70.00
61	23	3	90.00
62	24	1	50.00
63	24	2	70.00
64	24	3	90.00
65	25	1	50.00
66	25	2	70.00
67	26	1	50.00
68	26	2	70.00
69	26	3	90.00
70	27	1	50.00
71	27	2	70.00
72	27	3	90.00
73	28	1	50.00
74	28	2	70.00
75	29	1	50.00
76	29	2	70.00
77	29	3	90.00
78	30	1	50.00
79	30	2	70.00
80	30	3	90.00
81	31	1	5.00
82	31	2	7.00
83	32	1	5.00
84	32	2	7.00
85	32	3	9.00
86	33	1	5.00
87	33	2	7.00
88	33	3	9.00
89	34	1	5.00
90	34	2	7.00
91	35	1	50.00
92	35	2	70.00
93	35	3	90.00
94	36	1	50.00
95	36	2	70.00
96	36	3	90.00
97	37	1	50.00
98	37	2	70.00
99	38	1	50.00
100	38	2	70.00
101	38	3	90.00
102	39	1	50.00
103	39	2	70.00
104	39	3	90.00
105	40	1	50.00
106	40	2	70.00
107	41	1	50.00
108	41	2	70.00
109	41	3	90.00
110	42	1	50.00
111	42	2	70.00
112	42	3	90.00
113	43	1	50.00
114	43	2	70.00
115	44	1	50.00
116	44	2	70.00
117	44	3	90.00
118	45	1	50.00
119	45	2	70.00
120	45	3	90.00
121	46	1	50.00
122	46	2	70.00
123	47	1	50.00
124	47	2	70.00
125	47	3	90.00
126	48	1	50.00
127	48	2	70.00
128	48	3	90.00
129	49	1	50.00
130	49	2	70.00
131	50	1	50.00
132	50	2	70.00
133	50	3	90.00
134	51	1	50.00
135	51	2	70.00
136	51	3	90.00
137	52	1	50.00
138	52	2	70.00
139	53	1	50.00
140	53	2	70.00
141	53	3	90.00
142	54	1	50.00
143	54	2	70.00
144	54	3	90.00
145	55	1	50.00
146	55	2	70.00
147	56	1	50.00
148	56	2	70.00
149	56	3	90.00
150	57	1	50.00
151	57	2	70.00
152	57	3	90.00
153	58	1	50.00
154	58	2	70.00
155	59	1	50.00
156	59	2	70.00
157	59	3	90.00
158	60	1	50.00
159	60	2	70.00
160	60	3	90.00
161	61	1	50.00
162	61	2	70.00
163	62	1	50.00
164	62	2	70.00
165	62	3	90.00
166	63	1	50.00
167	63	2	70.00
168	63	3	90.00
169	64	1	50.00
170	64	2	70.00
171	65	1	50.00
172	65	2	70.00
173	65	3	90.00
174	66	1	50.00
175	66	2	70.00
176	66	3	90.00
177	67	1	50.00
178	67	2	70.00
179	68	1	50.00
180	68	2	70.00
181	68	3	90.00
182	69	1	50.00
183	69	2	70.00
184	69	3	90.00
185	70	1	50.00
186	70	2	70.00
187	71	1	50.00
188	71	2	70.00
189	71	3	90.00
190	72	1	50.00
191	72	2	70.00
192	72	3	90.00
193	73	1	50.00
194	73	2	70.00
195	74	1	50.00
196	74	2	70.00
197	74	3	90.00
198	75	1	50.00
199	75	2	70.00
200	75	3	90.00
201	76	1	50.00
202	76	2	70.00
203	77	1	50.00
204	77	2	70.00
205	77	3	90.00
206	78	1	50.00
207	78	2	70.00
208	78	3	90.00
209	79	1	50.00
210	79	2	70.00
211	80	1	50.00
212	80	2	70.00
213	80	3	90.00
214	81	1	50.00
215	81	2	70.00
216	81	3	90.00
217	82	1	50.00
218	82	2	70.00
219	83	1	50.00
220	83	2	70.00
221	83	3	90.00
222	84	1	50.00
223	84	2	70.00
224	84	3	90.00
225	85	1	50.00
226	85	2	70.00
227	86	1	50.00
228	86	2	70.00
229	86	3	90.00
230	87	1	50.00
231	87	2	70.00
232	87	3	90.00
233	88	1	50.00
234	88	2	70.00
235	89	1	500.00
236	89	2	700.00
237	89	3	900.00
238	90	1	500.00
239	90	2	700.00
240	90	3	900.00
241	91	1	500.00
242	91	2	700.00
243	92	1	500.00
244	92	2	700.00
245	92	3	900.00
246	93	1	500.00
247	93	2	700.00
248	93	3	900.00
249	94	1	500.00
250	94	2	700.00
251	95	1	500.00
252	95	2	700.00
253	95	3	900.00
254	96	1	500.00
255	96	2	700.00
256	96	3	900.00
257	97	1	50.00
258	97	2	70.00
259	98	1	50.00
260	98	2	70.00
261	98	3	90.00
262	99	1	50.00
263	99	2	70.00
264	99	3	90.00
265	100	1	50.00
266	100	2	70.00
267	101	1	50.00
268	101	2	70.00
269	101	3	90.00
270	102	1	50.00
271	102	2	70.00
272	102	3	90.00
273	103	1	50.00
274	103	2	70.00
275	104	1	5.00
276	104	2	7.00
277	104	3	9.00
278	105	1	50.00
279	105	2	70.00
280	105	3	90.00
281	106	1	50.00
282	106	2	70.00
283	107	1	50.00
284	107	2	70.00
285	107	3	90.00
286	108	1	50.00
287	108	2	70.00
288	108	3	90.00
289	109	1	50.00
290	109	2	70.00
291	110	1	50.00
292	110	2	70.00
293	110	3	90.00
294	111	1	50.00
295	111	2	70.00
296	111	3	90.00
297	112	1	50.00
298	112	2	70.00
299	113	1	50.00
300	113	2	70.00
301	113	3	90.00
302	114	1	50.00
303	114	2	70.00
304	114	3	90.00
305	115	1	50.00
306	115	2	70.00
307	116	1	50.00
308	116	2	70.00
309	116	3	90.00
310	117	1	50.00
311	117	2	70.00
312	117	3	90.00
313	118	1	50.00
314	118	2	70.00
315	119	1	50.00
316	119	2	70.00
317	119	3	90.00
318	120	1	50.00
319	120	2	70.00
320	120	3	90.00
321	121	1	50.00
322	121	2	70.00
323	122	1	50.00
324	122	2	70.00
325	122	3	90.00
326	123	1	50.00
327	123	2	70.00
328	123	3	90.00
329	124	1	50.00
330	124	2	70.00
331	125	1	50.00
332	125	2	70.00
333	125	3	90.00
334	126	1	50.00
335	126	2	70.00
336	126	3	90.00
337	127	1	50.00
338	127	2	70.00
339	128	1	50.00
340	128	2	70.00
341	128	3	90.00
342	129	1	50.00
343	129	2	70.00
344	129	3	90.00
345	130	1	50.00
346	130	2	70.00
347	131	1	50.00
348	131	2	70.00
349	131	3	90.00
350	132	1	50.00
351	132	2	70.00
352	132	3	90.00
353	133	1	50.00
354	133	2	70.00
355	134	1	50.00
356	134	2	70.00
357	134	3	90.00
358	135	1	50.00
359	135	2	70.00
360	135	3	90.00
361	136	1	50.00
362	136	2	70.00
363	137	1	50.00
364	137	2	70.00
365	137	3	90.00
366	138	1	50.00
367	138	2	70.00
368	138	3	90.00
\.


--
-- TOC entry 5276 (class 0 OID 38660)
-- Dependencies: 247
-- Data for Name: purchase; Type: TABLE DATA; Schema: public; Owner: -
--

COPY mrp.purchase (id, org_id, order_number, date, user_id, supplier_id, warehouse_id, total, status) FROM stdin;
\.


--
-- TOC entry 5284 (class 0 OID 38750)
-- Dependencies: 255
-- Data for Name: purchase_detail; Type: TABLE DATA; Schema: public; Owner: -
--

COPY mrp.purchase_detail (id, purchase_id, product_id, quantity, price, total) FROM stdin;
\.


--
-- TOC entry 5282 (class 0 OID 38729)
-- Dependencies: 253
-- Data for Name: report_audit; Type: TABLE DATA; Schema: public; Owner: -
--

COPY mrp.report_audit (id, ts, user_id, org_id, prompt, sql, rowcount, error, took_ms) FROM stdin;
\.


--
-- TOC entry 5265 (class 0 OID 30959)
-- Dependencies: 236
-- Data for Name: resource; Type: TABLE DATA; Schema: public; Owner: -
--

COPY mrp.resource (id, name, description) FROM stdin;
15	Inicio	Pantalla principal / Dashboard
16	Inventario	Gestión de inventario y stock
17	Producción	BOM, órdenes y ejecución
18	Proveedores	Maestro de proveedores
19	Planificación	Demanda, MPS y MRP
20	Administración	Usuarios, Roles y Seguridad
21	Reportes	Generación de reportes
22	Sistema	Configuración y mantenimiento
32	ProducciÃ³n	BOM, Ã³rdenes y ejecuciÃ³n
33	PlanificaciÃ³n	Demanda, MPS y MRP
34	AdministraciÃ³n	Usuarios, Roles y Seguridad
\.


--
-- TOC entry 5263 (class 0 OID 30947)
-- Dependencies: 234
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: -
--

COPY mrp.role (id, name, description, status) FROM stdin;
1	Admin	Administrador del sistema	t
2	Planner	Planificador / MRP	t
3	Supervisor	Supervisor de planta	t
4	Operator	Operario de planta	t
\.


--
-- TOC entry 5271 (class 0 OID 31047)
-- Dependencies: 242
-- Data for Name: role_resource; Type: TABLE DATA; Schema: public; Owner: -
--

COPY mrp.role_resource (role_id, resource_id, subresource_id) FROM stdin;
1	17	103
1	17	104
1	17	105
1	17	106
2	17	103
2	17	104
2	17	106
3	17	104
3	17	106
4	17	105
1	21	56
1	22	57
1	22	58
1	15	40
1	16	41
1	16	42
1	16	43
1	16	44
1	16	45
1	18	47
1	18	48
1	19	49
1	19	50
1	19	51
1	20	52
1	20	53
\.


--
-- TOC entry 5268 (class 0 OID 30981)
-- Dependencies: 239
-- Data for Name: subresource; Type: TABLE DATA; Schema: public; Owner: -
--

COPY mrp.subresource (id, resource_id, name, description, url, icon) FROM stdin;
56	21	Reportes IA	Generador de reportes con IA	/dashboard/reports/ai	pi pi-sparkles
57	22	Logs	Auditoría del sistema	/dashboard/system/logs	pi pi-file
58	22	Backup	Respaldo de datos	/dashboard/system/backup	pi pi-database
103	17	Lista de Materiales	ABM de BOMs	/dashboard/production/boms	pi pi-list
104	17	Órdenes de Producción	Gestión de órdenes de producción	/dashboard/production/work-orders	pi pi-calendar
105	17	Ejecución	Iniciar/Finalizar órdenes	/dashboard/production/execution	pi pi-cog
106	17	Reportes Producción	Reportes de producción	/dashboard/production/reports	pi pi-chart-bar
43	16	Movimientos	Entradas/Salidas/Transferencias/Ajustes	/dashboard/movements	pi pi-arrow-right-arrow-left
40	15	Dashboard	Indicadores y KPIs	/dashboard	pi pi-home
41	16	Productos	ABM de productos	/dashboard/products	pi pi-box
42	16	Almacenes	ABM de almacenes	/dashboard/warehouses	pi pi-building
44	16	Stock Bajo	Alertas de stock bajo	/dashboard/stocks/low	pi pi-exclamation-triangle
45	16	Sugerencias	Sugerencias de reposición	/dashboard/stocks/reorder-suggestions	pi pi-refresh
47	18	Proveedores	ABM de proveedores	/dashboard/suppliers	pi pi-truck
48	18	Catálogo Proveedor	Relación proveedor–producto	/dashboard/suppliers/supplier-items	pi pi-link
49	19	Demanda	Carga de demanda	/dashboard/demand	pi pi-database
50	19	MPS	Plan Maestro de Producción	/dashboard/mps	pi pi-calendar
51	19	MRP	Requerimientos de Materiales	/dashboard/mrp	pi pi-sitemap
52	20	Usuarios	ABM usuarios	/dashboard/users	pi pi-user
53	20	Roles	ABM roles	/dashboard/roles	pi pi-shield
\.


--
-- TOC entry 5251 (class 0 OID 30755)
-- Dependencies: 222
-- Data for Name: supplier; Type: TABLE DATA; Schema: public; Owner: -
--

COPY mrp.supplier (id, name, phone, mobile, address, city, email, org_id, status, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
1	Aceros Bolivia S.A.	+591-3-3334455	+591-70000001	Av. Industrial 456	Santa Cruz	aceros.bolivia@email.com	1	t	2025-11-07 09:37:25.807897	2025-11-07 09:37:25.807897	\N	\N	\N
2	Distribuidora Industrial SCZ	+591-3-3556677	+591-70000002	Zona Norte	Santa Cruz	ventas@disindustrial.bo	1	t	2025-11-07 09:37:25.807897	2025-11-07 09:37:25.807897	\N	\N	\N
3	Importadora La Paz	+591-2-2445566	+591-70000003	Calle Comercio 789	La Paz	info@implp.com.bo	1	t	2025-11-07 09:37:25.807897	2025-11-07 09:37:25.807897	\N	\N	\N
4	Suministros Industriales Cochabamba	+591-4-4223344	+591-70000004	Av. América 123	Cochabamba	suministros@sicbba.bo	1	t	2025-11-07 09:37:25.807897	2025-11-07 09:37:25.807897	\N	\N	\N
5	Ferretería Industrial del Sur	+591-3-3778899	+591-70000005	Radial 26	Santa Cruz	ventas@fersur.bo	1	t	2025-11-07 09:37:25.807897	2025-11-07 09:37:25.807897	\N	\N	\N
6	Steel Suppliers USA Inc.	+1-713-555-0123	+1-713-555-0124	Houston, TX 77001	Houston	sales@steelusa.com	1	t	2025-11-07 09:37:25.807897	2025-11-07 09:37:25.807897	\N	\N	\N
7	German Tools GmbH	+49-89-12345678	+49-89-12345679	Munich, Bavaria	Munich	export@germantools.de	1	t	2025-11-07 09:37:25.807897	2025-11-07 09:37:25.807897	\N	\N	\N
8	Shanghai Industrial Co.	+86-21-98765432	+86-21-98765433	Pudong District	Shanghai	info@shanghaiind.cn	1	t	2025-11-07 09:37:25.807897	2025-11-07 09:37:25.807897	\N	\N	\N
9	Brasil Componentes Ltda	+55-11-3456-7890	+55-11-3456-7891	São Paulo, SP	São Paulo	vendas@brasilcomp.com.br	1	t	2025-11-07 09:37:25.807897	2025-11-07 09:37:25.807897	\N	\N	\N
10	Argentina Metales S.A.	+54-11-4567-8901	+54-11-4567-8902	Buenos Aires	Buenos Aires	exportacion@argmetales.com.ar	1	t	2025-11-07 09:37:25.807897	2025-11-07 09:37:25.807897	\N	\N	\N
11	Eléctrica Industrial Santa Cruz	+591-3-3112233	+591-70000006	3er Anillo	Santa Cruz	electrica@eisc.bo	1	t	2025-11-07 09:37:25.807897	2025-11-07 09:37:25.807897	\N	\N	\N
12	Plásticos del Oriente	+591-3-3445566	+591-70000007	Parque Industrial	Santa Cruz	plasticos@oriente.bo	1	t	2025-11-07 09:37:25.807897	2025-11-07 09:37:25.807897	\N	\N	\N
13	Herramientas Profesionales Bolivia	+591-2-2667788	+591-70000008	El Alto	El Alto	herramientas@hpbolivia.bo	1	t	2025-11-07 09:37:25.807897	2025-11-07 09:37:25.807897	\N	\N	\N
\.


--
-- TOC entry 5259 (class 0 OID 30849)
-- Dependencies: 230
-- Data for Name: supplier_item; Type: TABLE DATA; Schema: public; Owner: -
--

COPY mrp.supplier_item (id, org_id, product_id, supplier_id, price, currency, lead_time_days, min_order_qty, pack_size, is_preferred, is_active) FROM stdin;
1	1	1	1	9.0000	BOB	3	10.0000	\N	t	t
2	1	1	6	10.0000	BOB	25	15.0000	\N	f	t
3	1	1	2	11.0000	BOB	11	20.0000	\N	f	t
4	1	2	2	9.0000	BOB	3	10.0000	\N	t	t
5	1	2	7	10.0000	BOB	25	15.0000	\N	f	t
6	1	3	3	9.0000	BOB	3	10.0000	\N	t	t
7	1	3	8	10.0000	BOB	25	15.0000	\N	f	t
8	1	3	4	11.0000	BOB	11	20.0000	\N	f	t
9	1	4	4	9.0000	BOB	3	10.0000	\N	t	t
10	1	4	9	10.0000	BOB	25	15.0000	\N	f	t
11	1	5	5	9.0000	BOB	3	10.0000	\N	t	t
12	1	5	10	10.0000	BOB	25	15.0000	\N	f	t
13	1	5	11	11.0000	BOB	11	20.0000	\N	f	t
14	1	6	11	9.0000	BOB	3	10.0000	\N	t	t
15	1	6	6	10.0000	BOB	25	15.0000	\N	f	t
16	1	7	12	9.0000	BOB	3	10.0000	\N	t	t
17	1	7	7	10.0000	BOB	25	15.0000	\N	f	t
18	1	7	13	11.0000	BOB	11	20.0000	\N	f	t
19	1	8	13	9.0000	BOB	3	10.0000	\N	t	t
20	1	8	8	10.0000	BOB	25	15.0000	\N	f	t
21	1	9	1	9.0000	BOB	3	10.0000	\N	t	t
22	1	9	9	10.0000	BOB	25	15.0000	\N	f	t
23	1	9	2	11.0000	BOB	11	20.0000	\N	f	t
24	1	10	2	9.0000	BOB	3	10.0000	\N	t	t
25	1	10	10	10.0000	BOB	25	15.0000	\N	f	t
26	1	11	3	9.0000	BOB	3	10.0000	\N	t	t
27	1	11	6	10.0000	BOB	25	15.0000	\N	f	t
28	1	11	4	11.0000	BOB	11	20.0000	\N	f	t
29	1	12	4	9.0000	BOB	3	10.0000	\N	t	t
30	1	12	7	10.0000	BOB	25	15.0000	\N	f	t
31	1	13	5	9.0000	BOB	3	10.0000	\N	t	t
32	1	13	8	10.0000	BOB	25	15.0000	\N	f	t
33	1	13	11	11.0000	BOB	11	20.0000	\N	f	t
34	1	14	11	9.0000	BOB	3	10.0000	\N	t	t
35	1	14	9	10.0000	BOB	25	15.0000	\N	f	t
36	1	15	12	9.0000	BOB	3	10.0000	\N	t	t
37	1	15	10	10.0000	BOB	25	15.0000	\N	f	t
38	1	15	13	11.0000	BOB	11	20.0000	\N	f	t
39	1	16	13	9.0000	BOB	3	10.0000	\N	t	t
40	1	16	6	10.0000	BOB	25	15.0000	\N	f	t
41	1	17	1	9.0000	BOB	3	10.0000	\N	t	t
42	1	17	7	10.0000	BOB	25	15.0000	\N	f	t
43	1	17	2	11.0000	BOB	11	20.0000	\N	f	t
44	1	18	2	9.0000	BOB	3	10.0000	\N	t	t
45	1	18	8	10.0000	BOB	25	15.0000	\N	f	t
46	1	19	3	9.0000	BOB	3	10.0000	\N	t	t
47	1	19	9	10.0000	BOB	25	15.0000	\N	f	t
48	1	19	4	11.0000	BOB	11	20.0000	\N	f	t
49	1	20	4	9.0000	BOB	3	10.0000	\N	t	t
50	1	20	10	10.0000	BOB	25	15.0000	\N	f	t
51	1	21	5	9.0000	BOB	3	10.0000	\N	t	t
52	1	21	6	10.0000	BOB	25	15.0000	\N	f	t
53	1	21	11	11.0000	BOB	11	20.0000	\N	f	t
54	1	22	11	9.0000	BOB	3	10.0000	\N	t	t
55	1	22	7	10.0000	BOB	25	15.0000	\N	f	t
56	1	23	12	9.0000	BOB	3	10.0000	\N	t	t
57	1	23	8	10.0000	BOB	25	15.0000	\N	f	t
58	1	23	13	11.0000	BOB	11	20.0000	\N	f	t
59	1	24	13	9.0000	BOB	3	10.0000	\N	t	t
60	1	24	9	10.0000	BOB	25	15.0000	\N	f	t
61	1	25	1	9.0000	BOB	3	10.0000	\N	t	t
62	1	25	10	10.0000	BOB	25	15.0000	\N	f	t
63	1	25	2	11.0000	BOB	11	20.0000	\N	f	t
64	1	26	2	9.0000	BOB	3	10.0000	\N	t	t
65	1	26	6	10.0000	BOB	25	15.0000	\N	f	t
66	1	27	3	9.0000	BOB	3	10.0000	\N	t	t
67	1	27	7	10.0000	BOB	25	15.0000	\N	f	t
68	1	27	4	11.0000	BOB	11	20.0000	\N	f	t
69	1	28	4	9.0000	BOB	3	10.0000	\N	t	t
70	1	28	8	10.0000	BOB	25	15.0000	\N	f	t
71	1	29	5	9.0000	BOB	3	10.0000	\N	t	t
72	1	29	9	10.0000	BOB	25	15.0000	\N	f	t
73	1	29	11	11.0000	BOB	11	20.0000	\N	f	t
74	1	30	11	9.0000	BOB	3	10.0000	\N	t	t
75	1	30	10	10.0000	BOB	25	15.0000	\N	f	t
76	1	31	12	9.0000	BOB	3	1.0000	\N	t	t
77	1	31	6	10.0000	BOB	25	2.0000	\N	f	t
78	1	31	13	11.0000	BOB	11	3.0000	\N	f	t
79	1	32	13	9.0000	BOB	3	1.0000	\N	t	t
80	1	32	7	10.0000	BOB	25	2.0000	\N	f	t
81	1	33	1	9.0000	BOB	3	1.0000	\N	t	t
82	1	33	8	10.0000	BOB	25	2.0000	\N	f	t
83	1	33	2	11.0000	BOB	11	3.0000	\N	f	t
84	1	34	2	9.0000	BOB	3	1.0000	\N	t	t
85	1	34	9	10.0000	BOB	25	2.0000	\N	f	t
86	1	35	3	9.0000	BOB	3	10.0000	\N	t	t
87	1	35	10	10.0000	BOB	25	15.0000	\N	f	t
88	1	35	4	11.0000	BOB	11	20.0000	\N	f	t
89	1	36	4	9.0000	BOB	3	10.0000	\N	t	t
90	1	36	6	10.0000	BOB	25	15.0000	\N	f	t
91	1	37	5	9.0000	BOB	3	10.0000	\N	t	t
92	1	37	7	10.0000	BOB	25	15.0000	\N	f	t
93	1	37	11	11.0000	BOB	11	20.0000	\N	f	t
94	1	38	11	9.0000	BOB	3	10.0000	\N	t	t
95	1	38	8	10.0000	BOB	25	15.0000	\N	f	t
96	1	39	12	9.0000	BOB	3	10.0000	\N	t	t
97	1	39	9	10.0000	BOB	25	15.0000	\N	f	t
98	1	39	13	11.0000	BOB	11	20.0000	\N	f	t
99	1	40	13	9.0000	BOB	3	10.0000	\N	t	t
100	1	40	10	10.0000	BOB	25	15.0000	\N	f	t
101	1	41	1	9.0000	BOB	3	10.0000	\N	t	t
102	1	41	6	10.0000	BOB	25	15.0000	\N	f	t
103	1	41	2	11.0000	BOB	11	20.0000	\N	f	t
104	1	42	2	9.0000	BOB	3	10.0000	\N	t	t
105	1	42	7	10.0000	BOB	25	15.0000	\N	f	t
106	1	43	3	9.0000	BOB	3	10.0000	\N	t	t
107	1	43	8	10.0000	BOB	25	15.0000	\N	f	t
108	1	43	4	11.0000	BOB	11	20.0000	\N	f	t
109	1	44	4	9.0000	BOB	3	10.0000	\N	t	t
110	1	44	9	10.0000	BOB	25	15.0000	\N	f	t
111	1	45	5	9.0000	BOB	3	10.0000	\N	t	t
112	1	45	10	10.0000	BOB	25	15.0000	\N	f	t
113	1	45	11	11.0000	BOB	11	20.0000	\N	f	t
114	1	46	11	9.0000	BOB	3	10.0000	\N	t	t
115	1	46	6	10.0000	BOB	25	15.0000	\N	f	t
116	1	47	12	9.0000	BOB	3	10.0000	\N	t	t
117	1	47	7	10.0000	BOB	25	15.0000	\N	f	t
118	1	47	13	11.0000	BOB	11	20.0000	\N	f	t
119	1	48	13	9.0000	BOB	3	10.0000	\N	t	t
120	1	48	8	10.0000	BOB	25	15.0000	\N	f	t
121	1	49	1	9.0000	BOB	3	10.0000	\N	t	t
122	1	49	9	10.0000	BOB	25	15.0000	\N	f	t
123	1	49	2	11.0000	BOB	11	20.0000	\N	f	t
124	1	50	2	9.0000	BOB	3	10.0000	\N	t	t
125	1	50	10	10.0000	BOB	25	15.0000	\N	f	t
126	1	51	3	9.0000	BOB	3	10.0000	\N	t	t
127	1	51	6	10.0000	BOB	25	15.0000	\N	f	t
128	1	51	4	11.0000	BOB	11	20.0000	\N	f	t
129	1	52	4	9.0000	BOB	3	10.0000	\N	t	t
130	1	52	7	10.0000	BOB	25	15.0000	\N	f	t
131	1	53	5	9.0000	BOB	3	10.0000	\N	t	t
132	1	53	8	10.0000	BOB	25	15.0000	\N	f	t
133	1	53	11	11.0000	BOB	11	20.0000	\N	f	t
134	1	54	11	9.0000	BOB	3	10.0000	\N	t	t
135	1	54	9	10.0000	BOB	25	15.0000	\N	f	t
136	1	55	12	9.0000	BOB	3	10.0000	\N	t	t
137	1	55	10	10.0000	BOB	25	15.0000	\N	f	t
138	1	55	13	11.0000	BOB	11	20.0000	\N	f	t
139	1	56	13	9.0000	BOB	3	10.0000	\N	t	t
140	1	56	6	10.0000	BOB	25	15.0000	\N	f	t
141	1	57	1	9.0000	BOB	3	10.0000	\N	t	t
142	1	57	7	10.0000	BOB	25	15.0000	\N	f	t
143	1	57	2	11.0000	BOB	11	20.0000	\N	f	t
144	1	58	2	9.0000	BOB	3	10.0000	\N	t	t
145	1	58	8	10.0000	BOB	25	15.0000	\N	f	t
146	1	59	3	9.0000	BOB	3	10.0000	\N	t	t
147	1	59	9	10.0000	BOB	25	15.0000	\N	f	t
148	1	59	4	11.0000	BOB	11	20.0000	\N	f	t
149	1	60	4	9.0000	BOB	3	10.0000	\N	t	t
150	1	60	10	10.0000	BOB	25	15.0000	\N	f	t
151	1	61	5	9.0000	BOB	3	10.0000	\N	t	t
152	1	61	6	10.0000	BOB	25	15.0000	\N	f	t
153	1	61	11	11.0000	BOB	11	20.0000	\N	f	t
154	1	62	11	9.0000	BOB	3	10.0000	\N	t	t
155	1	62	7	10.0000	BOB	25	15.0000	\N	f	t
156	1	63	12	9.0000	BOB	3	10.0000	\N	t	t
157	1	63	8	10.0000	BOB	25	15.0000	\N	f	t
158	1	63	13	11.0000	BOB	11	20.0000	\N	f	t
159	1	64	13	9.0000	BOB	3	10.0000	\N	t	t
160	1	64	9	10.0000	BOB	25	15.0000	\N	f	t
161	1	65	1	9.0000	BOB	3	10.0000	\N	t	t
162	1	65	10	10.0000	BOB	25	15.0000	\N	f	t
163	1	65	2	11.0000	BOB	11	20.0000	\N	f	t
164	1	66	2	9.0000	BOB	3	10.0000	\N	t	t
165	1	66	6	10.0000	BOB	25	15.0000	\N	f	t
166	1	67	3	9.0000	BOB	3	10.0000	\N	t	t
167	1	67	7	10.0000	BOB	25	15.0000	\N	f	t
168	1	67	4	11.0000	BOB	11	20.0000	\N	f	t
169	1	68	4	9.0000	BOB	3	10.0000	\N	t	t
170	1	68	8	10.0000	BOB	25	15.0000	\N	f	t
171	1	69	5	9.0000	BOB	3	10.0000	\N	t	t
172	1	69	9	10.0000	BOB	25	15.0000	\N	f	t
173	1	69	11	11.0000	BOB	11	20.0000	\N	f	t
174	1	70	11	9.0000	BOB	3	10.0000	\N	t	t
175	1	70	10	10.0000	BOB	25	15.0000	\N	f	t
176	1	71	12	9.0000	BOB	3	10.0000	\N	t	t
177	1	71	6	10.0000	BOB	25	15.0000	\N	f	t
178	1	71	13	11.0000	BOB	11	20.0000	\N	f	t
179	1	72	13	9.0000	BOB	3	10.0000	\N	t	t
180	1	72	7	10.0000	BOB	25	15.0000	\N	f	t
181	1	73	1	9.0000	BOB	3	10.0000	\N	t	t
182	1	73	8	10.0000	BOB	25	15.0000	\N	f	t
183	1	73	2	11.0000	BOB	11	20.0000	\N	f	t
184	1	74	2	9.0000	BOB	3	10.0000	\N	t	t
185	1	74	9	10.0000	BOB	25	15.0000	\N	f	t
186	1	75	3	9.0000	BOB	3	10.0000	\N	t	t
187	1	75	10	10.0000	BOB	25	15.0000	\N	f	t
188	1	75	4	11.0000	BOB	11	20.0000	\N	f	t
189	1	76	4	9.0000	BOB	3	10.0000	\N	t	t
190	1	76	6	10.0000	BOB	25	15.0000	\N	f	t
191	1	77	5	9.0000	BOB	3	10.0000	\N	t	t
192	1	77	7	10.0000	BOB	25	15.0000	\N	f	t
193	1	77	11	11.0000	BOB	11	20.0000	\N	f	t
194	1	78	11	9.0000	BOB	3	10.0000	\N	t	t
195	1	78	8	10.0000	BOB	25	15.0000	\N	f	t
196	1	79	12	9.0000	BOB	3	10.0000	\N	t	t
197	1	79	9	10.0000	BOB	25	15.0000	\N	f	t
198	1	79	13	11.0000	BOB	11	20.0000	\N	f	t
199	1	80	13	9.0000	BOB	3	10.0000	\N	t	t
200	1	80	10	10.0000	BOB	25	15.0000	\N	f	t
201	1	81	1	9.0000	BOB	3	10.0000	\N	t	t
202	1	81	6	10.0000	BOB	25	15.0000	\N	f	t
203	1	81	2	11.0000	BOB	11	20.0000	\N	f	t
204	1	82	2	9.0000	BOB	3	10.0000	\N	t	t
205	1	82	7	10.0000	BOB	25	15.0000	\N	f	t
206	1	83	3	9.0000	BOB	3	10.0000	\N	t	t
207	1	83	8	10.0000	BOB	25	15.0000	\N	f	t
208	1	83	4	11.0000	BOB	11	20.0000	\N	f	t
209	1	84	4	9.0000	BOB	3	10.0000	\N	t	t
210	1	84	9	10.0000	BOB	25	15.0000	\N	f	t
211	1	85	5	9.0000	BOB	3	10.0000	\N	t	t
212	1	85	10	10.0000	BOB	25	15.0000	\N	f	t
213	1	85	11	11.0000	BOB	11	20.0000	\N	f	t
214	1	86	11	9.0000	BOB	3	10.0000	\N	t	t
215	1	86	6	10.0000	BOB	25	15.0000	\N	f	t
216	1	87	12	9.0000	BOB	3	10.0000	\N	t	t
217	1	87	7	10.0000	BOB	25	15.0000	\N	f	t
218	1	87	13	11.0000	BOB	11	20.0000	\N	f	t
219	1	88	13	9.0000	BOB	3	10.0000	\N	t	t
220	1	88	8	10.0000	BOB	25	15.0000	\N	f	t
221	1	89	1	9.0000	BOB	3	100.0000	\N	t	t
222	1	89	9	10.0000	BOB	25	150.0000	\N	f	t
223	1	89	2	11.0000	BOB	11	200.0000	\N	f	t
224	1	90	2	9.0000	BOB	3	100.0000	\N	t	t
225	1	90	10	10.0000	BOB	25	150.0000	\N	f	t
226	1	91	3	9.0000	BOB	3	100.0000	\N	t	t
227	1	91	6	10.0000	BOB	25	150.0000	\N	f	t
228	1	91	4	11.0000	BOB	11	200.0000	\N	f	t
229	1	92	4	9.0000	BOB	3	100.0000	\N	t	t
230	1	92	7	10.0000	BOB	25	150.0000	\N	f	t
231	1	93	5	9.0000	BOB	3	100.0000	\N	t	t
232	1	93	8	10.0000	BOB	25	150.0000	\N	f	t
233	1	93	11	11.0000	BOB	11	200.0000	\N	f	t
234	1	94	11	9.0000	BOB	3	100.0000	\N	t	t
235	1	94	9	10.0000	BOB	25	150.0000	\N	f	t
236	1	95	12	9.0000	BOB	3	100.0000	\N	t	t
237	1	95	10	10.0000	BOB	25	150.0000	\N	f	t
238	1	95	13	11.0000	BOB	11	200.0000	\N	f	t
239	1	96	13	9.0000	BOB	3	100.0000	\N	t	t
240	1	96	6	10.0000	BOB	25	150.0000	\N	f	t
241	1	97	1	9.0000	BOB	3	10.0000	\N	t	t
242	1	97	7	10.0000	BOB	25	15.0000	\N	f	t
243	1	97	2	11.0000	BOB	11	20.0000	\N	f	t
244	1	98	2	9.0000	BOB	3	10.0000	\N	t	t
245	1	98	8	10.0000	BOB	25	15.0000	\N	f	t
246	1	99	3	9.0000	BOB	3	10.0000	\N	t	t
247	1	99	9	10.0000	BOB	25	15.0000	\N	f	t
248	1	99	4	11.0000	BOB	11	20.0000	\N	f	t
249	1	100	4	9.0000	BOB	3	10.0000	\N	t	t
250	1	100	10	10.0000	BOB	25	15.0000	\N	f	t
251	1	101	5	9.0000	BOB	3	10.0000	\N	t	t
252	1	101	6	10.0000	BOB	25	15.0000	\N	f	t
253	1	101	11	11.0000	BOB	11	20.0000	\N	f	t
254	1	102	11	9.0000	BOB	3	10.0000	\N	t	t
255	1	102	7	10.0000	BOB	25	15.0000	\N	f	t
256	1	103	12	9.0000	BOB	3	10.0000	\N	t	t
257	1	103	8	10.0000	BOB	25	15.0000	\N	f	t
258	1	103	13	11.0000	BOB	11	20.0000	\N	f	t
259	1	104	13	9.0000	BOB	3	10.0000	\N	t	t
260	1	104	9	10.0000	BOB	25	15.0000	\N	f	t
261	1	105	1	9.0000	BOB	3	10.0000	\N	t	t
262	1	105	10	10.0000	BOB	25	15.0000	\N	f	t
263	1	105	2	11.0000	BOB	11	20.0000	\N	f	t
264	1	106	2	9.0000	BOB	3	10.0000	\N	t	t
265	1	106	6	10.0000	BOB	25	15.0000	\N	f	t
266	1	107	3	9.0000	BOB	3	10.0000	\N	t	t
267	1	107	7	10.0000	BOB	25	15.0000	\N	f	t
268	1	107	4	11.0000	BOB	11	20.0000	\N	f	t
269	1	108	4	9.0000	BOB	3	10.0000	\N	t	t
270	1	108	8	10.0000	BOB	25	15.0000	\N	f	t
271	1	109	5	9.0000	BOB	3	10.0000	\N	t	t
272	1	109	9	10.0000	BOB	25	15.0000	\N	f	t
273	1	109	11	11.0000	BOB	11	20.0000	\N	f	t
274	1	110	11	9.0000	BOB	3	10.0000	\N	t	t
275	1	110	10	10.0000	BOB	25	15.0000	\N	f	t
276	1	111	12	9.0000	BOB	3	10.0000	\N	t	t
277	1	111	6	10.0000	BOB	25	15.0000	\N	f	t
278	1	111	13	11.0000	BOB	11	20.0000	\N	f	t
279	1	112	13	9.0000	BOB	3	10.0000	\N	t	t
280	1	112	7	10.0000	BOB	25	15.0000	\N	f	t
281	1	113	1	9.0000	BOB	3	10.0000	\N	t	t
282	1	113	8	10.0000	BOB	25	15.0000	\N	f	t
283	1	113	2	11.0000	BOB	11	20.0000	\N	f	t
284	1	114	2	9.0000	BOB	3	10.0000	\N	t	t
285	1	114	9	10.0000	BOB	25	15.0000	\N	f	t
286	1	115	3	9.0000	BOB	3	10.0000	\N	t	t
287	1	115	10	10.0000	BOB	25	15.0000	\N	f	t
288	1	115	4	11.0000	BOB	11	20.0000	\N	f	t
289	1	116	4	9.0000	BOB	3	10.0000	\N	t	t
290	1	116	6	10.0000	BOB	25	15.0000	\N	f	t
291	1	117	5	9.0000	BOB	3	10.0000	\N	t	t
292	1	117	7	10.0000	BOB	25	15.0000	\N	f	t
293	1	117	11	11.0000	BOB	11	20.0000	\N	f	t
294	1	118	11	9.0000	BOB	3	10.0000	\N	t	t
295	1	118	8	10.0000	BOB	25	15.0000	\N	f	t
296	1	119	12	9.0000	BOB	3	10.0000	\N	t	t
297	1	119	9	10.0000	BOB	25	15.0000	\N	f	t
298	1	119	13	11.0000	BOB	11	20.0000	\N	f	t
299	1	120	13	9.0000	BOB	3	10.0000	\N	t	t
300	1	120	10	10.0000	BOB	25	15.0000	\N	f	t
301	1	121	1	9.0000	BOB	3	10.0000	\N	t	t
302	1	121	6	10.0000	BOB	25	15.0000	\N	f	t
303	1	121	2	11.0000	BOB	11	20.0000	\N	f	t
304	1	122	2	9.0000	BOB	3	10.0000	\N	t	t
305	1	122	7	10.0000	BOB	25	15.0000	\N	f	t
306	1	123	3	9.0000	BOB	3	10.0000	\N	t	t
307	1	123	8	10.0000	BOB	25	15.0000	\N	f	t
308	1	123	4	11.0000	BOB	11	20.0000	\N	f	t
309	1	124	4	9.0000	BOB	3	10.0000	\N	t	t
310	1	124	9	10.0000	BOB	25	15.0000	\N	f	t
311	1	125	5	9.0000	BOB	3	10.0000	\N	t	t
312	1	125	10	10.0000	BOB	25	15.0000	\N	f	t
313	1	125	11	11.0000	BOB	11	20.0000	\N	f	t
314	1	126	11	9.0000	BOB	3	10.0000	\N	t	t
315	1	126	6	10.0000	BOB	25	15.0000	\N	f	t
316	1	127	12	9.0000	BOB	3	1.0000	\N	t	t
317	1	127	7	10.0000	BOB	25	2.0000	\N	f	t
318	1	127	13	11.0000	BOB	11	3.0000	\N	f	t
319	1	128	13	9.0000	BOB	3	1.0000	\N	t	t
320	1	128	8	10.0000	BOB	25	2.0000	\N	f	t
321	1	129	1	9.0000	BOB	3	1.0000	\N	t	t
322	1	129	9	10.0000	BOB	25	2.0000	\N	f	t
323	1	129	2	11.0000	BOB	11	3.0000	\N	f	t
324	1	130	2	9.0000	BOB	3	10.0000	\N	t	t
325	1	130	10	10.0000	BOB	25	15.0000	\N	f	t
326	1	131	3	9.0000	BOB	3	10.0000	\N	t	t
327	1	131	6	10.0000	BOB	25	15.0000	\N	f	t
328	1	131	4	11.0000	BOB	11	20.0000	\N	f	t
329	1	132	4	9.0000	BOB	3	10.0000	\N	t	t
330	1	132	7	10.0000	BOB	25	15.0000	\N	f	t
331	1	133	5	9.0000	BOB	3	10.0000	\N	t	t
332	1	133	8	10.0000	BOB	25	15.0000	\N	f	t
333	1	133	11	11.0000	BOB	11	20.0000	\N	f	t
334	1	134	11	9.0000	BOB	3	10.0000	\N	t	t
335	1	134	9	10.0000	BOB	25	15.0000	\N	f	t
336	1	135	12	9.0000	BOB	3	10.0000	\N	t	t
337	1	135	10	10.0000	BOB	25	15.0000	\N	f	t
338	1	135	13	11.0000	BOB	11	20.0000	\N	f	t
339	1	136	13	9.0000	BOB	3	10.0000	\N	t	t
340	1	136	6	10.0000	BOB	25	15.0000	\N	f	t
341	1	137	1	9.0000	BOB	3	10.0000	\N	t	t
342	1	137	7	10.0000	BOB	25	15.0000	\N	f	t
343	1	137	2	11.0000	BOB	11	20.0000	\N	f	t
344	1	138	2	9.0000	BOB	3	10.0000	\N	t	t
345	1	138	8	10.0000	BOB	25	15.0000	\N	f	t
\.


--
-- TOC entry 5280 (class 0 OID 38707)
-- Dependencies: 251
-- Data for Name: system_log; Type: TABLE DATA; Schema: public; Owner: -
--

COPY mrp.system_log (id, ts, user_id, org_id, action, path, method, ip, status_code) FROM stdin;
1	2025-10-13 20:46:22.626929	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
2	2025-10-13 20:47:22.031954	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
3	2025-10-13 20:47:24.110422	6	1	GET /api/users	/api/users	GET	127.0.0.1	200
4	2025-10-13 20:47:28.362048	\N	\N	GET /api/users	/api/users	GET	127.0.0.1	200
5	2025-10-13 20:47:30.406173	\N	\N	GET /api/users	/api/users	GET	127.0.0.1	200
6	2025-10-13 20:48:02.342061	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
7	2025-10-13 20:50:35.584556	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
8	2025-10-13 20:50:36.470305	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	401
9	2025-10-13 20:50:56.795531	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
10	2025-10-13 20:50:59.098456	6	1	GET /api/users	/api/users	GET	127.0.0.1	200
11	2025-10-13 20:51:09.143763	\N	\N	GET /api/users	/api/users	GET	127.0.0.1	200
12	2025-10-13 20:51:11.82068	\N	\N	GET /api/users	/api/users	GET	127.0.0.1	200
13	2025-10-13 20:51:33.663154	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
14	2025-10-13 20:51:34.15183	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	401
15	2025-10-13 20:58:09.779565	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
16	2025-10-13 20:58:11.928395	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	401
17	2025-10-13 20:58:13.954954	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	401
18	2025-10-13 20:58:20.974669	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
19	2025-10-13 20:58:21.147305	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	401
20	2025-10-13 20:58:24.094705	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	401
21	2025-10-13 20:58:35.110159	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
22	2025-10-13 20:58:35.300236	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	401
23	2025-10-13 20:58:53.604298	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
24	2025-10-13 20:58:53.985658	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	401
25	2025-10-13 20:59:36.717685	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
26	2025-10-13 20:59:36.952371	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
27	2025-10-13 20:59:41.135929	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
28	2025-10-13 21:03:35.79959	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
29	2025-10-13 21:07:42.995845	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
30	2025-10-13 21:07:45.056024	6	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
31	2025-10-13 21:07:54.612182	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
32	2025-10-13 21:08:34.248632	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
33	2025-10-13 21:09:45.217368	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
34	2025-10-13 21:09:47.279443	6	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
35	2025-10-13 21:10:16.672151	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
36	2025-10-13 21:10:16.702311	4	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
37	2025-10-13 21:10:28.174601	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
38	2025-10-13 21:10:28.19611	4	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
39	2025-10-13 21:10:39.249493	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
40	2025-10-13 21:10:39.27006	4	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
41	2025-10-13 21:11:30.831079	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
42	2025-10-13 21:11:32.921982	6	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
43	2025-10-14 02:05:51.678479	\N	\N	GET /api/menu	/api/menu	GET	127.0.0.1	401
44	2025-10-14 02:06:06.439419	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
45	2025-10-14 02:06:09.392639	\N	\N	GET /api/menu	/api/menu	GET	127.0.0.1	401
46	2025-10-14 02:07:06.387575	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
47	2025-10-14 02:07:14.555774	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
48	2025-10-14 02:07:42.63928	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
49	2025-10-14 02:07:42.66463	\N	\N	GET /api/menu	/api/menu	GET	127.0.0.1	401
50	2025-10-14 02:40:12.608247	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
51	2025-10-14 02:40:12.970343	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
52	2025-10-14 02:40:14.630937	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
53	2025-10-14 02:40:14.66677	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
54	2025-10-14 02:43:10.699029	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
55	2025-10-14 02:43:10.739352	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
56	2025-10-14 02:43:29.206926	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
57	2025-10-14 02:43:29.232219	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
58	2025-10-14 02:43:34.305683	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
59	2025-10-14 02:43:34.33471	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
60	2025-10-14 02:45:18.742564	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
61	2025-10-14 02:45:19.023587	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
62	2025-10-14 02:45:22.860494	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
63	2025-10-14 02:45:22.948767	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
64	2025-10-14 02:45:28.612625	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
65	2025-10-14 02:45:28.685167	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
66	2025-10-14 03:03:35.566671	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
67	2025-10-14 03:03:35.675319	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
68	2025-10-14 03:03:35.778182	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
69	2025-10-14 03:03:36.396549	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
70	2025-10-14 03:03:41.966047	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
71	2025-10-14 03:03:42.054282	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
72	2025-10-14 03:09:46.241046	\N	\N	GET /api/logs	/api/logs	GET	127.0.0.1	401
73	2025-10-14 03:09:46.238994	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
74	2025-10-14 03:09:46.298751	\N	\N	GET /api/logs	/api/logs	GET	127.0.0.1	401
75	2025-10-14 03:09:46.303269	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
76	2025-10-14 03:17:25.164486	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
77	2025-10-14 03:17:26.041679	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
78	2025-10-24 18:07:37.534232	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
79	2025-10-24 18:07:37.726196	\N	\N	GET /api/menu	/api/menu	GET	127.0.0.1	422
80	2025-10-24 18:11:45.589513	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
81	2025-10-24 18:11:46.00681	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
82	2025-10-24 18:11:47.673808	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
83	2025-10-24 18:11:47.737295	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
84	2025-10-24 18:12:25.028015	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
85	2025-10-24 18:12:33.608073	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
86	2025-10-24 18:12:33.651535	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
87	2025-10-24 18:13:48.327348	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
88	2025-10-24 18:13:54.651641	\N	\N	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	401
89	2025-10-24 18:14:26.313196	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
90	2025-10-24 18:14:28.410076	6	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
91	2025-10-24 18:14:30.471931	6	1	GET /api/dashboard/alerts	/api/dashboard/alerts	GET	127.0.0.1	200
92	2025-10-24 18:14:32.583152	\N	\N	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	401
93	2025-10-24 20:48:13.688907	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
94	2025-10-24 20:48:15.741088	\N	\N	GET /api/products	/api/products	GET	127.0.0.1	401
95	2025-10-24 20:48:17.797533	6	1	GET /api/products	/api/products	GET	127.0.0.1	200
96	2025-10-24 20:48:45.609022	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
97	2025-10-24 20:48:47.652066	\N	\N	GET /api/products	/api/products	GET	127.0.0.1	401
98	2025-10-24 20:48:49.690052	6	1	GET /api/products	/api/products	GET	127.0.0.1	200
99	2025-10-24 20:51:36.722878	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
100	2025-10-24 20:51:38.772015	\N	\N	GET /api/products	/api/products	GET	127.0.0.1	401
101	2025-10-24 20:51:40.856674	6	1	GET /api/products	/api/products	GET	127.0.0.1	200
102	2025-10-24 20:51:42.937117	6	1	POST /api/products	/api/products	POST	127.0.0.1	422
103	2025-10-24 20:53:15.287986	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
104	2025-10-24 20:53:17.37915	\N	\N	GET /api/products	/api/products	GET	127.0.0.1	401
105	2025-10-24 20:53:19.475083	6	1	GET /api/products	/api/products	GET	127.0.0.1	200
106	2025-10-24 20:53:21.534677	6	1	POST /api/products	/api/products	POST	127.0.0.1	422
107	2025-10-24 20:53:51.913944	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
108	2025-10-24 20:53:53.954859	\N	\N	GET /api/products	/api/products	GET	127.0.0.1	401
109	2025-10-24 20:53:56.003785	6	1	GET /api/products	/api/products	GET	127.0.0.1	200
110	2025-10-24 20:53:58.039476	6	1	POST /api/products	/api/products	POST	127.0.0.1	422
111	2025-10-24 20:57:30.678544	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
112	2025-10-24 20:57:32.71233	\N	\N	GET /api/products	/api/products	GET	127.0.0.1	401
113	2025-10-24 20:57:34.751173	6	1	GET /api/products	/api/products	GET	127.0.0.1	200
114	2025-10-24 20:57:36.821193	6	1	POST /api/products	/api/products	POST	127.0.0.1	200
115	2025-10-24 20:57:38.858296	6	1	GET /api/products/12	/api/products/12	GET	127.0.0.1	200
116	2025-10-24 20:57:40.904791	6	1	PUT /api/products/12	/api/products/12	PUT	127.0.0.1	200
117	2025-10-24 20:57:42.957882	6	1	DELETE /api/products/12	/api/products/12	DELETE	127.0.0.1	200
118	2025-10-24 21:02:22.527712	\N	\N	GET /api/logs	/api/logs	GET	127.0.0.1	401
119	2025-10-24 21:02:22.656842	\N	\N	GET /api/logs	/api/logs	GET	127.0.0.1	401
120	2025-10-24 21:03:35.705478	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
121	2025-10-24 21:03:35.720552	\N	\N	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	401
122	2025-10-24 21:03:38.856331	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
123	2025-10-24 21:03:38.869433	\N	\N	GET /api/products	/api/products	GET	127.0.0.1	401
124	2025-10-24 21:07:20.978689	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
125	2025-10-24 21:07:23.054429	\N	\N	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	401
126	2025-10-24 21:07:25.102328	\N	\N	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	422
127	2025-10-24 21:07:46.652343	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
128	2025-10-24 21:07:48.682912	\N	\N	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	401
129	2025-10-24 21:07:50.735006	\N	\N	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	422
130	2025-10-24 21:07:58.832999	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
131	2025-10-24 21:08:00.867226	\N	\N	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	422
132	2025-10-24 21:08:10.107912	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
133	2025-10-24 21:08:46.994051	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
134	2025-10-24 21:08:47.009458	\N	\N	GET /api/menu	/api/menu	GET	127.0.0.1	401
135	2025-10-24 21:08:47.183133	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
136	2025-10-24 21:08:47.261363	\N	\N	GET /api/products	/api/products	GET	127.0.0.1	401
137	2025-10-24 21:09:18.165201	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
138	2025-10-24 21:09:18.384006	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
139	2025-10-24 21:09:19.924379	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
140	2025-10-24 21:09:19.965553	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
141	2025-10-24 21:09:50.454927	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
142	2025-10-24 21:09:50.473925	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
143	2025-10-24 21:09:52.30884	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
144	2025-10-24 21:09:52.352158	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
145	2025-10-24 21:10:52.205937	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
146	2025-10-24 21:10:52.238654	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
147	2025-10-24 21:10:52.300934	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
148	2025-10-24 21:10:52.323089	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
149	2025-10-24 21:10:54.970864	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
150	2025-10-24 21:10:54.981532	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
151	2025-10-24 21:10:59.912869	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
152	2025-10-24 21:11:00.467735	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
153	2025-10-24 21:11:07.002748	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
155	2025-10-24 21:11:11.381061	\N	\N	GET /api/logs	/api/logs	GET	127.0.0.1	401
157	2025-10-24 21:11:15.871065	\N	\N	GET /api/user-org	/api/user-org	GET	127.0.0.1	404
159	2025-10-24 21:11:19.78134	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
1242	2025-10-29 16:53:45.72036	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1246	2025-10-29 16:54:17.924223	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1250	2025-10-29 16:54:20.830749	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
1254	2025-10-29 16:56:13.201342	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1258	2025-10-29 16:56:21.634712	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
1554	2025-10-31 12:31:53.863204	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1556	2025-10-31 12:31:56.795098	\N	\N	OPTIONS /api/logs	/api/logs	OPTIONS	127.0.0.1	200
1560	2025-10-31 12:33:14.466695	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1563	2025-10-31 12:34:44.920324	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1567	2025-10-31 12:34:45.070702	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1570	2025-10-31 12:35:11.828264	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1572	2025-10-31 12:35:11.874018	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1575	2025-10-31 12:35:49.476403	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
1578	2025-10-31 12:35:51.621731	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
1581	2025-10-31 12:35:56.775585	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1584	2025-10-31 12:35:58.667348	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1587	2025-10-31 12:35:59.144158	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1590	2025-10-31 12:35:59.624348	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1593	2025-10-31 12:36:01.604601	\N	\N	OPTIONS /api/movements	/api/movements	OPTIONS	127.0.0.1	200
1596	2025-10-31 12:36:03.128661	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1599	2025-10-31 12:36:41.748836	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1602	2025-10-31 12:36:42.610068	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
1785	2025-10-31 15:59:56.103326	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1788	2025-10-31 15:59:56.492753	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1792	2025-10-31 16:00:08.114906	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1797	2025-10-31 16:00:28.914491	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1802	2025-10-31 16:00:46.221315	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1969	2025-10-31 16:35:38.105368	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1973	2025-10-31 16:35:39.717666	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
1977	2025-10-31 16:35:39.808116	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1981	2025-10-31 16:35:48.48056	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1983	2025-10-31 16:35:48.544979	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1987	2025-10-31 16:40:05.519698	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2176	2025-10-31 18:43:58.641993	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2177	2025-10-31 18:43:58.681339	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
2179	2025-10-31 18:44:00.204478	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2182	2025-10-31 18:44:00.220166	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
2185	2025-10-31 18:44:00.312581	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
2186	2025-10-31 18:44:02.6117	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
2189	2025-10-31 18:44:30.427754	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2192	2025-10-31 18:44:30.469855	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2385	2025-11-03 03:51:55.087201	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2391	2025-11-03 03:51:55.162495	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
2396	2025-11-03 03:52:11.167807	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
2402	2025-11-03 03:52:13.356737	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
2408	2025-11-03 03:52:21.760222	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
2530	2025-11-05 05:23:46.917011	\N	\N	POST /api/login	/api/login	POST	127.0.0.1	404
2721	2025-11-05 15:16:17.12152	\N	\N	GET /api/products	/api/products	GET	127.0.0.1	401
2726	2025-11-05 15:16:29.793706	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
2730	2025-11-05 15:16:29.925699	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
2734	2025-11-05 15:16:32.124648	\N	\N	OPTIONS /api/suppliers	/api/suppliers	OPTIONS	127.0.0.1	200
2739	2025-11-05 15:17:12.922543	\N	\N	OPTIONS /api/supplier-items/4/toggle-active	/api/supplier-items/4/toggle-active	OPTIONS	127.0.0.1	404
2743	2025-11-05 15:17:24.932199	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
2748	2025-11-05 15:17:26.99066	\N	\N	OPTIONS /api/suppliers	/api/suppliers	OPTIONS	127.0.0.1	200
2753	2025-11-05 15:17:35.873732	\N	\N	OPTIONS /api/supplier-items/5/toggle-active	/api/supplier-items/5/toggle-active	OPTIONS	127.0.0.1	404
2874	2025-11-05 16:15:29.384067	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2878	2025-11-05 16:15:30.418201	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
2881	2025-11-05 16:15:30.552388	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2885	2025-11-05 16:15:31.410078	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2889	2025-11-05 16:15:34.992317	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2894	2025-11-05 16:15:35.102279	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2897	2025-11-05 16:15:38.518934	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2901	2025-11-05 16:15:38.584366	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2906	2025-11-05 16:15:48.470613	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2911	2025-11-05 16:15:56.344059	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2916	2025-11-05 16:15:57.391908	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
2921	2025-11-05 16:15:59.79079	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
154	2025-10-24 21:11:08.506295	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
156	2025-10-24 21:11:11.384759	\N	\N	GET /api/logs	/api/logs	GET	127.0.0.1	401
158	2025-10-24 21:11:15.872818	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
160	2025-10-24 21:12:03.165202	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
161	2025-10-24 21:14:40.448193	\N	\N	GET /api/menu	/api/menu	GET	127.0.0.1	401
162	2025-10-24 21:14:56.518266	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
163	2025-10-24 21:41:51.348515	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
164	2025-10-24 21:46:05.706708	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
165	2025-10-24 21:46:07.748711	\N	\N	GET /api/menu	/api/menu	GET	127.0.0.1	422
166	2025-10-24 21:46:15.569216	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
167	2025-10-24 21:46:17.615755	\N	\N	GET /api/products	/api/products	GET	127.0.0.1	401
168	2025-10-24 21:46:19.674802	6	1	GET /api/products	/api/products	GET	127.0.0.1	200
169	2025-10-24 21:46:21.783396	6	1	POST /api/products	/api/products	POST	127.0.0.1	200
170	2025-10-24 21:46:23.841082	6	1	GET /api/products/13	/api/products/13	GET	127.0.0.1	200
171	2025-10-24 21:46:25.899231	6	1	PUT /api/products/13	/api/products/13	PUT	127.0.0.1	200
172	2025-10-24 21:46:27.951713	6	1	DELETE /api/products/13	/api/products/13	DELETE	127.0.0.1	200
173	2025-10-24 21:46:57.372897	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
174	2025-10-24 21:46:57.499627	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
175	2025-10-24 21:46:57.678092	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
176	2025-10-24 21:47:02.19804	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
177	2025-10-24 21:47:02.264085	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
178	2025-10-24 21:47:03.624398	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
179	2025-10-24 21:47:03.650587	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
180	2025-10-24 21:47:19.693389	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
181	2025-10-24 21:47:19.695637	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
182	2025-10-24 21:47:19.72633	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
183	2025-10-24 21:47:19.730649	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
184	2025-10-24 21:47:35.783668	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
185	2025-10-24 21:49:20.994659	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
186	2025-10-24 21:49:21.018327	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
187	2025-10-24 21:49:21.946113	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
188	2025-10-24 21:49:21.967036	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
189	2025-10-24 21:51:58.575645	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
190	2025-10-24 21:51:58.60247	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
191	2025-10-24 21:51:58.66579	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
192	2025-10-24 21:51:58.705623	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
193	2025-10-24 21:52:05.102595	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
194	2025-10-24 21:52:05.10435	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
195	2025-10-24 21:52:05.130703	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
196	2025-10-24 21:52:05.132767	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
197	2025-10-25 02:19:39.025186	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
198	2025-10-25 02:19:39.042921	\N	\N	GET /api/menu	/api/menu	GET	127.0.0.1	401
199	2025-10-25 02:19:43.341141	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
200	2025-10-25 02:19:43.352523	\N	\N	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	401
201	2025-10-25 02:19:54.096171	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
202	2025-10-25 02:19:54.289535	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
203	2025-10-25 02:19:55.820368	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
204	2025-10-25 02:19:55.851811	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
205	2025-10-25 02:20:00.769165	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
206	2025-10-25 02:20:05.270549	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
207	2025-10-25 02:20:05.296453	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
208	2025-10-25 02:20:09.146566	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
209	2025-10-25 02:20:11.36494	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
210	2025-10-25 02:20:12.9402	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
211	2025-10-25 02:20:19.403262	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
212	2025-10-25 02:20:19.431134	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
213	2025-10-25 02:20:22.449591	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
214	2025-10-25 02:20:23.385577	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
215	2025-10-25 02:20:23.39803	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
216	2025-10-25 02:20:32.879966	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
217	2025-10-25 02:20:32.911216	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
218	2025-10-25 02:20:32.927576	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
219	2025-10-25 02:20:33.028999	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
220	2025-10-25 02:20:35.892138	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
221	2025-10-25 02:20:35.904941	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
222	2025-10-25 02:20:38.024197	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
223	2025-10-25 02:20:38.033056	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
224	2025-10-25 02:20:38.050082	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
225	2025-10-25 02:20:38.05632	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
226	2025-10-25 02:20:39.403522	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
227	2025-10-25 02:20:39.433185	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
228	2025-10-25 02:20:53.623844	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
229	2025-10-25 02:20:53.631416	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
230	2025-10-25 02:20:53.652623	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
231	2025-10-25 02:20:53.657418	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
232	2025-10-25 02:20:55.704823	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
234	2025-10-25 02:21:05.740652	\N	\N	GET /api/logs	/api/logs	GET	127.0.0.1	401
236	2025-10-25 02:21:19.634632	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
238	2025-10-25 02:21:23.747225	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
1243	2025-10-29 16:53:45.810927	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1247	2025-10-29 16:54:18.021135	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1251	2025-10-29 16:54:20.88525	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1256	2025-10-29 16:56:13.264586	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
1555	2025-10-31 12:31:54.007213	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1558	2025-10-31 12:33:05.422279	\N	\N	OPTIONS /api/product-warehouses	/api/product-warehouses	OPTIONS	127.0.0.1	200
1561	2025-10-31 12:33:14.490837	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1564	2025-10-31 12:34:45.003311	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1565	2025-10-31 12:34:45.050341	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1568	2025-10-31 12:35:11.811055	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1571	2025-10-31 12:35:11.854098	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1574	2025-10-31 12:35:49.403684	\N	\N	OPTIONS /api/movements	/api/movements	OPTIONS	127.0.0.1	200
1577	2025-10-31 12:35:50.667489	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1580	2025-10-31 12:35:56.765661	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1583	2025-10-31 12:35:57.870929	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1586	2025-10-31 12:35:58.964285	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1589	2025-10-31 12:35:59.465987	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1592	2025-10-31 12:36:00.506145	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1595	2025-10-31 12:36:03.110265	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1598	2025-10-31 12:36:14.240341	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
1601	2025-10-31 12:36:42.574681	\N	\N	OPTIONS /api/movements	/api/movements	OPTIONS	127.0.0.1	200
1786	2025-10-31 15:59:56.18434	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1790	2025-10-31 15:59:56.591921	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1795	2025-10-31 16:00:14.258086	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
1800	2025-10-31 16:00:39.733221	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
1804	2025-10-31 16:00:46.258389	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1970	2025-10-31 16:35:38.124796	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1974	2025-10-31 16:35:39.720885	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1976	2025-10-31 16:35:39.788655	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
1980	2025-10-31 16:35:48.472559	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1984	2025-10-31 16:35:48.570179	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1988	2025-10-31 16:40:05.522712	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2193	2025-10-31 18:52:50.093438	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2197	2025-10-31 18:52:50.18651	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2201	2025-10-31 18:52:50.239309	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2205	2025-10-31 18:54:27.836264	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2209	2025-10-31 18:54:33.844449	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
2213	2025-10-31 18:54:33.896127	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
2218	2025-10-31 18:54:37.772244	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
2222	2025-10-31 18:55:03.322485	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2228	2025-10-31 18:55:07.649018	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
2386	2025-11-03 03:51:55.0932	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
2393	2025-11-03 03:51:55.197163	\N	\N	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	401
2399	2025-11-03 03:52:13.335304	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
2403	2025-11-03 03:52:13.573468	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2409	2025-11-03 03:52:21.78509	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
2531	2025-11-05 05:24:42.854577	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
2532	2025-11-05 05:24:44.920191	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
2533	2025-11-05 05:24:46.98716	1	1	GET /api/boms/1	/api/boms/1	GET	127.0.0.1	200
2534	2025-11-05 05:24:49.016162	1	1	GET /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	GET	127.0.0.1	200
2535	2025-11-05 05:24:51.079584	1	1	POST /api/boms	/api/boms	POST	127.0.0.1	201
2536	2025-11-05 05:24:53.142738	1	1	PUT /api/boms/4	/api/boms/4	PUT	127.0.0.1	200
2537	2025-11-05 05:24:55.214945	1	1	DELETE /api/boms/4	/api/boms/4	DELETE	127.0.0.1	200
2538	2025-11-05 05:24:57.253065	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2539	2025-11-05 05:24:59.316827	1	1	GET /api/work-orders/1	/api/work-orders/1	GET	127.0.0.1	200
2540	2025-11-05 05:25:01.394592	1	1	POST /api/work-orders	/api/work-orders	POST	127.0.0.1	201
2541	2025-11-05 05:25:03.498866	1	1	PUT /api/work-orders/3/start	/api/work-orders/3/start	PUT	127.0.0.1	200
2542	2025-11-05 05:25:07.609144	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
2754	2025-11-05 15:31:22.515502	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	401
2875	2025-11-05 16:15:29.39059	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2879	2025-11-05 16:15:30.445807	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2882	2025-11-05 16:15:30.555998	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
2888	2025-11-05 16:15:33.015665	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
2892	2025-11-05 16:15:35.012016	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
2896	2025-11-05 16:15:35.137052	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
2900	2025-11-05 16:15:38.56462	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2905	2025-11-05 16:15:48.440043	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2912	2025-11-05 16:15:56.371218	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
233	2025-10-25 02:21:05.732759	\N	\N	GET /api/logs	/api/logs	GET	127.0.0.1	401
235	2025-10-25 02:21:19.632088	\N	\N	GET /api/user-org	/api/user-org	GET	127.0.0.1	404
237	2025-10-25 02:21:22.0965	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
239	2025-10-25 04:20:56.955108	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
240	2025-10-25 04:27:34.158677	\N	\N	GET /api/menu	/api/menu	GET	127.0.0.1	401
241	2025-10-25 04:27:38.469235	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
242	2025-10-25 04:27:41.526637	\N	\N	GET /api/menu	/api/menu	GET	127.0.0.1	401
243	2025-10-25 04:28:34.289595	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
244	2025-10-25 04:31:00.229468	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
245	2025-10-25 04:31:00.259982	\N	\N	GET /api/menu	/api/menu	GET	127.0.0.1	401
246	2025-10-25 04:31:00.492226	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
247	2025-10-25 04:31:17.225955	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
248	2025-10-25 04:31:17.241828	\N	\N	GET /api/menu	/api/menu	GET	127.0.0.1	401
249	2025-10-25 04:31:17.261024	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
250	2025-10-25 04:31:45.656261	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
251	2025-10-25 04:31:45.885367	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
252	2025-10-25 04:31:49.708705	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
253	2025-10-25 04:31:49.745326	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
254	2025-10-25 04:33:38.566137	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
255	2025-10-25 04:33:38.618041	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
256	2025-10-25 04:36:36.229505	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
257	2025-10-25 04:36:36.432772	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
258	2025-10-25 04:42:11.119812	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
259	2025-10-25 04:42:11.189439	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
260	2025-10-25 04:42:11.202185	\N	\N	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	401
261	2025-10-25 04:42:11.246347	\N	\N	GET /api/dashboard/alerts	/api/dashboard/alerts	GET	127.0.0.1	401
262	2025-10-25 04:42:11.317447	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
263	2025-10-25 04:45:56.526137	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
264	2025-10-25 04:45:56.681291	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
265	2025-10-25 04:45:56.688589	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
266	2025-10-25 04:45:56.692123	\N	\N	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	401
267	2025-10-25 04:45:56.706896	\N	\N	GET /api/dashboard/alerts	/api/dashboard/alerts	GET	127.0.0.1	401
268	2025-10-25 04:45:56.741727	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
269	2025-10-25 04:47:15.039825	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
270	2025-10-25 04:47:17.671578	\N	\N	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	401
271	2025-10-25 04:47:17.675101	\N	\N	GET /api/dashboard/alerts	/api/dashboard/alerts	GET	127.0.0.1	401
272	2025-10-25 04:47:17.679674	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
273	2025-10-25 17:52:09.013076	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
274	2025-10-25 17:52:09.246051	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
275	2025-10-25 17:52:09.31621	\N	\N	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	401
276	2025-10-25 17:52:09.34771	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
277	2025-10-25 17:52:09.349728	\N	\N	GET /api/dashboard/alerts	/api/dashboard/alerts	GET	127.0.0.1	401
278	2025-10-25 17:52:09.692836	\N	\N	GET /api/menu	/api/menu	GET	127.0.0.1	401
279	2025-10-25 17:58:25.044108	\N	\N	POST /api/auth/refresh	/api/auth/refresh	POST	127.0.0.1	200
280	2025-10-25 17:58:38.466627	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
281	2025-10-25 18:20:35.249016	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
282	2025-10-25 18:20:35.289029	\N	\N	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	401
283	2025-10-25 18:20:35.358532	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
284	2025-10-25 18:20:35.365134	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
285	2025-10-25 18:20:35.475848	\N	\N	GET /api/dashboard/alerts	/api/dashboard/alerts	GET	127.0.0.1	401
286	2025-10-25 18:20:36.155322	\N	\N	GET /api/menu	/api/menu	GET	127.0.0.1	401
287	2025-10-25 18:20:54.7305	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
288	2025-10-25 18:20:54.931336	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
289	2025-10-25 18:20:56.513504	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
290	2025-10-25 18:20:56.530804	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
291	2025-10-25 18:20:56.534746	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
292	2025-10-25 18:20:56.542028	\N	\N	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	401
293	2025-10-25 18:20:56.543516	\N	\N	GET /api/dashboard/alerts	/api/dashboard/alerts	GET	127.0.0.1	401
294	2025-10-25 18:20:56.573781	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
295	2025-10-25 18:21:01.661443	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
296	2025-10-25 18:21:01.694453	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
297	2025-10-25 18:21:09.420082	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
298	2025-10-25 18:21:09.458789	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
299	2025-10-27 15:06:55.613967	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
300	2025-10-27 15:06:55.802927	\N	\N	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	401
301	2025-10-27 15:07:11.55357	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
302	2025-10-27 15:07:11.919834	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
303	2025-10-27 15:07:13.494467	\N	\N	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	401
304	2025-10-27 15:07:13.498229	\N	\N	GET /api/dashboard/alerts	/api/dashboard/alerts	GET	127.0.0.1	401
305	2025-10-27 15:07:13.503808	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
306	2025-10-27 15:07:13.518731	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
307	2025-10-27 15:07:13.560959	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
308	2025-10-27 15:07:13.618838	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
309	2025-10-27 15:07:19.551592	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1244	2025-10-29 16:53:47.640347	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
1248	2025-10-29 16:54:20.321132	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1252	2025-10-29 16:56:13.197293	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
1257	2025-10-29 16:56:13.267091	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1557	2025-10-31 12:31:56.897274	\N	\N	OPTIONS /api/logs	/api/logs	OPTIONS	127.0.0.1	200
1559	2025-10-31 12:33:05.473187	1	1	GET /api/product-warehouses	/api/product-warehouses	GET	127.0.0.1	200
1562	2025-10-31 12:34:44.917319	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1566	2025-10-31 12:34:45.056338	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1569	2025-10-31 12:35:11.8146	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1573	2025-10-31 12:35:11.883589	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1576	2025-10-31 12:35:50.647456	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1579	2025-10-31 12:35:53.532389	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1582	2025-10-31 12:35:57.368987	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1585	2025-10-31 12:35:58.817289	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1588	2025-10-31 12:35:59.281676	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1591	2025-10-31 12:35:59.916189	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1594	2025-10-31 12:36:01.618647	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
1597	2025-10-31 12:36:14.230333	\N	\N	OPTIONS /api/movements	/api/movements	OPTIONS	127.0.0.1	200
1600	2025-10-31 12:36:41.835924	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1787	2025-10-31 15:59:56.489746	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1793	2025-10-31 16:00:08.173907	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1798	2025-10-31 16:00:36.441081	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1803	2025-10-31 16:00:46.224377	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1971	2025-10-31 16:35:38.144059	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1975	2025-10-31 16:35:39.727052	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
1979	2025-10-31 16:35:48.469559	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1985	2025-10-31 16:35:48.578798	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2194	2025-10-31 18:52:50.093438	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
2200	2025-10-31 18:52:50.226091	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
2204	2025-10-31 18:54:27.824551	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2208	2025-10-31 18:54:33.839532	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
2211	2025-10-31 18:54:33.874261	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
2214	2025-10-31 18:54:37.722155	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
2217	2025-10-31 18:54:37.755071	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
2221	2025-10-31 18:55:03.320364	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2225	2025-10-31 18:55:07.557172	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
2387	2025-11-03 03:51:55.081993	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
2390	2025-11-03 03:51:55.162495	\N	\N	GET /api/menu	/api/menu	GET	127.0.0.1	401
2397	2025-11-03 03:52:11.484717	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
2406	2025-11-03 03:52:13.715097	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
2543	2025-11-05 05:25:49.431015	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
2544	2025-11-05 05:25:51.514396	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
2545	2025-11-05 05:25:53.594712	1	1	GET /api/boms/1	/api/boms/1	GET	127.0.0.1	200
2546	2025-11-05 05:25:55.663308	1	1	GET /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	GET	127.0.0.1	200
2547	2025-11-05 05:25:57.739769	1	1	POST /api/boms	/api/boms	POST	127.0.0.1	201
2548	2025-11-05 05:25:59.795061	1	1	PUT /api/boms/5	/api/boms/5	PUT	127.0.0.1	200
2549	2025-11-05 05:26:01.872277	1	1	DELETE /api/boms/5	/api/boms/5	DELETE	127.0.0.1	200
2550	2025-11-05 05:26:03.933916	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2551	2025-11-05 05:26:05.994176	1	1	GET /api/work-orders/1	/api/work-orders/1	GET	127.0.0.1	200
2552	2025-11-05 05:26:08.076562	1	1	POST /api/work-orders	/api/work-orders	POST	127.0.0.1	201
2553	2025-11-05 05:26:10.167682	1	1	PUT /api/work-orders/4/start	/api/work-orders/4/start	PUT	127.0.0.1	200
2554	2025-11-05 05:26:12.227067	1	1	PUT /api/work-orders/4/finish	/api/work-orders/4/finish	PUT	127.0.0.1	200
2555	2025-11-05 05:26:14.266562	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
2755	2025-11-05 15:31:59.42802	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	401
2876	2025-11-05 16:15:29.833858	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2880	2025-11-05 16:15:30.456368	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
2884	2025-11-05 16:15:31.384159	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2886	2025-11-05 16:15:32.983814	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
2890	2025-11-05 16:15:34.999865	\N	\N	OPTIONS /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	OPTIONS	127.0.0.1	200
2895	2025-11-05 16:15:35.10328	1	1	GET /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	GET	127.0.0.1	200
2898	2025-11-05 16:15:38.522939	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
2903	2025-11-05 16:15:38.606999	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
2908	2025-11-05 16:15:56.258974	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2913	2025-11-05 16:15:57.37657	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2917	2025-11-05 16:15:57.451851	1	1	GET /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	GET	127.0.0.1	200
2922	2025-11-05 16:15:59.836369	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2967	2025-11-05 16:44:17.761004	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
2968	2025-11-05 16:44:22.594336	1	1	REPORT_NL ok=True rows=3 err=	/api/reports/nl	POST	127.0.0.1	\N
3017	2025-11-05 18:19:41.056277	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
3047	2025-11-05 19:28:44.617281	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
3280	2025-11-07 19:09:00.087772	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
310	2025-10-27 15:07:19.577202	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1245	2025-10-29 16:53:47.665787	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1249	2025-10-29 16:54:20.347117	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1253	2025-10-29 16:56:13.197293	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1255	2025-10-29 16:56:13.263587	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1259	2025-10-29 16:56:21.674999	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1603	2025-10-31 12:37:05.156768	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1605	2025-10-31 12:37:05.358899	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1607	2025-10-31 12:37:24.129434	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1611	2025-10-31 12:37:35.663526	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1616	2025-10-31 12:37:35.837008	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1619	2025-10-31 12:37:43.092417	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1621	2025-10-31 12:38:15.659928	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1624	2025-10-31 12:38:15.685322	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
1625	2025-10-31 12:38:15.737997	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1628	2025-10-31 12:38:19.52325	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1631	2025-10-31 12:38:39.965592	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
1635	2025-10-31 12:38:40.059165	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1638	2025-10-31 12:38:50.533438	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1641	2025-10-31 12:38:50.678541	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1791	2025-10-31 15:59:56.678648	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
1796	2025-10-31 16:00:28.879171	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1801	2025-10-31 16:00:39.849789	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1806	2025-10-31 16:01:06.445652	\N	\N	OPTIONS /api/work-orders/2/start	/api/work-orders/2/start	OPTIONS	127.0.0.1	200
1972	2025-10-31 16:35:38.187669	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1978	2025-10-31 16:35:39.836628	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
1982	2025-10-31 16:35:48.485563	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
1986	2025-10-31 16:35:48.599894	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
2195	2025-10-31 18:52:50.105342	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
2198	2025-10-31 18:52:50.200657	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
2202	2025-10-31 18:54:27.80315	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2206	2025-10-31 18:54:33.833705	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2212	2025-10-31 18:54:33.889229	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2216	2025-10-31 18:54:37.728162	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
2220	2025-10-31 18:55:03.308229	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2224	2025-10-31 18:55:07.553172	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2226	2025-10-31 18:55:07.629674	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
2388	2025-11-03 03:51:55.122741	\N	\N	OPTIONS /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	OPTIONS	127.0.0.1	200
2394	2025-11-03 03:51:55.22624	\N	\N	GET /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	GET	127.0.0.1	401
2400	2025-11-03 03:52:13.342043	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2404	2025-11-03 03:52:13.619459	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2410	2025-11-03 03:52:23.301776	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
2556	2025-11-05 05:33:08.219602	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2560	2025-11-05 05:33:08.99403	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2563	2025-11-05 05:33:09.335677	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2567	2025-11-05 05:33:12.538403	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
2571	2025-11-05 05:34:09.828561	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2575	2025-11-05 05:34:09.942956	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
2579	2025-11-05 05:34:09.976951	1	1	GET /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	GET	127.0.0.1	200
2583	2025-11-05 05:34:25.145735	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
2588	2025-11-05 05:34:25.218081	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
2593	2025-11-05 05:34:35.728139	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
2600	2025-11-05 05:34:35.81804	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
2605	2025-11-05 05:34:59.147469	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
2609	2025-11-05 05:34:59.196484	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
2614	2025-11-05 05:35:11.660245	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
2618	2025-11-05 05:35:11.740066	1	1	GET /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	GET	127.0.0.1	200
2756	2025-11-05 15:32:33.585374	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
2757	2025-11-05 15:32:35.627736	1	1	GET /api/supplier-items	/api/supplier-items	GET	127.0.0.1	200
2758	2025-11-05 15:32:37.69141	1	1	PUT /api/supplier-items/2/set-preferred	/api/supplier-items/2/set-preferred	PUT	127.0.0.1	200
2759	2025-11-05 15:32:39.734694	1	1	PUT /api/supplier-items/2/toggle-active	/api/supplier-items/2/toggle-active	PUT	127.0.0.1	200
2760	2025-11-05 15:32:41.788767	1	1	PUT /api/supplier-items/2/toggle-active	/api/supplier-items/2/toggle-active	PUT	127.0.0.1	200
2761	2025-11-05 15:35:32.008125	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2762	2025-11-05 15:35:32.105299	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2766	2025-11-05 15:35:32.265299	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
2770	2025-11-05 15:35:32.486798	1	1	GET /api/suppliers	/api/suppliers	GET	127.0.0.1	200
2776	2025-11-05 15:35:45.547063	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
2780	2025-11-05 15:35:45.721886	1	1	GET /api/suppliers	/api/suppliers	GET	127.0.0.1	200
2783	2025-11-05 15:36:09.665079	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2787	2025-11-05 15:36:09.73291	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
311	2025-10-27 15:07:22.272551	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1260	2025-10-29 17:01:38.008984	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1263	2025-10-29 17:01:38.525219	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1267	2025-10-29 17:01:59.737585	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1271	2025-10-29 17:01:59.841654	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1275	2025-10-29 17:02:22.213779	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1279	2025-10-29 17:02:44.405133	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1283	2025-10-29 17:02:44.907865	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1287	2025-10-29 17:03:14.184694	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1291	2025-10-29 17:03:14.362296	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1295	2025-10-29 17:04:48.139522	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1299	2025-10-29 17:05:57.187469	1	1	GET /api/product-warehouses	/api/product-warehouses	GET	127.0.0.1	200
1326	2025-10-30 13:43:30.149428	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1327	2025-10-30 13:43:30.204819	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
1329	2025-10-30 13:43:30.262748	\N	\N	GET /api/menu	/api/menu	GET	127.0.0.1	401
1331	2025-10-30 13:43:42.533114	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
1333	2025-10-30 13:43:44.247417	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1334	2025-10-30 13:43:44.331102	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1341	2025-10-30 13:43:44.525181	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
1388	2025-10-31 11:41:56.799866	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1389	2025-10-31 11:41:56.865334	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
1390	2025-10-31 11:41:56.959461	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
1393	2025-10-31 11:41:57.045511	\N	\N	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	401
1397	2025-10-31 11:42:17.075664	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
1401	2025-10-31 11:42:26.299665	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	401
1405	2025-10-31 11:42:49.540257	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
1409	2025-10-31 11:42:51.117257	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1414	2025-10-31 11:42:51.516128	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
1419	2025-10-31 11:43:02.526568	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1424	2025-10-31 11:43:10.059591	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1429	2025-10-31 11:43:54.389245	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1604	2025-10-31 12:37:05.287144	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1606	2025-10-31 12:37:24.126209	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
1608	2025-10-31 12:37:24.135916	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
1609	2025-10-31 12:37:24.188163	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1612	2025-10-31 12:37:35.669055	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1615	2025-10-31 12:37:35.82985	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1618	2025-10-31 12:37:43.09067	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1620	2025-10-31 12:37:43.142807	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1622	2025-10-31 12:38:15.668962	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1633	2025-10-31 12:38:39.973697	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
1636	2025-10-31 12:38:50.501435	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1640	2025-10-31 12:38:50.675543	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1807	2025-10-31 16:06:45.565542	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
1808	2025-10-31 16:06:47.667381	1	1	PUT /api/work-orders/2/start	/api/work-orders/2/start	PUT	127.0.0.1	400
1989	2025-10-31 16:40:05.76091	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2196	2025-10-31 18:52:50.121178	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
2199	2025-10-31 18:52:50.225097	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
2203	2025-10-31 18:54:27.805245	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2207	2025-10-31 18:54:33.836201	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2210	2025-10-31 18:54:33.871757	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2215	2025-10-31 18:54:37.727165	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2219	2025-10-31 18:55:03.305869	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2223	2025-10-31 18:55:07.550165	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
2227	2025-10-31 18:55:07.63473	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2389	2025-11-03 03:51:55.124758	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
2395	2025-11-03 03:51:55.31784	\N	\N	GET /api/users	/api/users	GET	127.0.0.1	200
2401	2025-11-03 03:52:13.348805	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2407	2025-11-03 03:52:13.753634	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
2557	2025-11-05 05:33:08.407658	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
2561	2025-11-05 05:33:09.027766	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
2565	2025-11-05 05:33:12.523639	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
2570	2025-11-05 05:33:12.616884	1	1	GET /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	GET	127.0.0.1	200
2573	2025-11-05 05:34:09.881085	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
2577	2025-11-05 05:34:09.952041	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
2581	2025-11-05 05:34:25.138043	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2585	2025-11-05 05:34:25.157752	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
2586	2025-11-05 05:34:25.194037	1	1	GET /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	GET	127.0.0.1	200
2592	2025-11-05 05:34:35.713142	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
2596	2025-11-05 05:34:35.76032	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
2601	2025-11-05 05:34:59.090677	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3357	2025-11-07 20:13:05.923771	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
312	2025-10-27 15:07:22.309648	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
313	2025-10-27 17:56:50.401943	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
314	2025-10-27 17:56:50.621376	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
315	2025-10-27 17:56:52.194586	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
316	2025-10-27 17:56:52.203084	\N	\N	GET /api/dashboard/alerts	/api/dashboard/alerts	GET	127.0.0.1	401
317	2025-10-27 17:56:52.298649	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
318	2025-10-27 17:56:52.319574	\N	\N	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	401
319	2025-10-27 17:56:52.321329	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
320	2025-10-27 17:56:52.403353	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
321	2025-10-27 17:57:11.426701	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
322	2025-10-27 17:57:11.481559	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
323	2025-10-27 17:59:18.139692	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
324	2025-10-27 17:59:18.28277	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
325	2025-10-27 17:59:18.28777	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
326	2025-10-27 17:59:18.347049	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
327	2025-10-27 17:59:18.37834	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
328	2025-10-27 17:59:21.016501	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
329	2025-10-27 17:59:21.055151	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
330	2025-10-27 18:04:42.676624	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
331	2025-10-27 18:15:28.447786	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
332	2025-10-27 18:15:28.514247	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
333	2025-10-27 18:15:28.562405	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
334	2025-10-27 18:15:28.584779	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
335	2025-10-27 18:15:28.659285	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
336	2025-10-27 18:15:35.782201	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
337	2025-10-27 18:15:38.297866	\N	\N	GET /api/menu	/api/menu	GET	127.0.0.1	401
338	2025-10-27 18:15:53.023992	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
339	2025-10-27 18:20:36.150799	\N	\N	GET /api/menu	/api/menu	GET	127.0.0.1	422
340	2025-10-27 18:20:42.937211	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	401
341	2025-10-27 18:20:43.181952	\N	\N	GET /api/menu	/api/menu	GET	127.0.0.1	422
342	2025-10-27 18:20:49.284216	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	400
343	2025-10-27 18:20:56.633335	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	401
344	2025-10-27 18:21:18.755746	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
345	2025-10-27 18:22:54.497108	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	401
346	2025-10-27 18:23:28.302995	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
347	2025-10-27 18:23:30.372034	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
348	2025-10-27 18:23:32.424789	\N	\N	POST /api/auth/refresh	/api/auth/refresh	POST	127.0.0.1	200
349	2025-10-27 18:23:41.223969	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
350	2025-10-27 18:29:41.199499	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
351	2025-10-27 18:57:36.912503	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
352	2025-10-27 18:57:36.943621	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
353	2025-10-27 18:57:36.954798	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
354	2025-10-27 18:57:36.958499	\N	\N	GET /api/menu	/api/menu	GET	127.0.0.1	401
355	2025-10-27 18:57:36.969939	\N	\N	GET /api/products	/api/products	GET	127.0.0.1	401
356	2025-10-27 19:01:47.692432	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
357	2025-10-27 19:01:47.932058	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
358	2025-10-27 19:01:49.492235	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
359	2025-10-27 19:01:49.501355	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
360	2025-10-27 19:01:49.501355	\N	\N	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	401
361	2025-10-27 19:01:49.510821	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
362	2025-10-27 19:01:49.525675	\N	\N	GET /api/dashboard/alerts	/api/dashboard/alerts	GET	127.0.0.1	401
363	2025-10-27 19:01:49.561123	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
364	2025-10-27 19:02:01.222896	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
365	2025-10-27 19:02:01.271159	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
366	2025-10-27 19:02:06.895782	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
367	2025-10-27 19:02:06.940399	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
368	2025-10-27 19:02:19.475279	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
369	2025-10-27 19:02:19.480788	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
370	2025-10-27 19:02:19.484399	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
371	2025-10-27 19:02:19.510151	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
372	2025-10-27 19:02:19.516354	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
373	2025-10-27 19:02:22.194949	\N	\N	OPTIONS /api/api/work-orders	/api/api/work-orders	OPTIONS	127.0.0.1	404
374	2025-10-27 19:02:22.196961	\N	\N	OPTIONS /api/api/work-orders	/api/api/work-orders	OPTIONS	127.0.0.1	404
375	2025-10-27 19:08:35.259985	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
376	2025-10-27 19:08:35.285145	\N	\N	OPTIONS /api/api/work-orders	/api/api/work-orders	OPTIONS	127.0.0.1	404
377	2025-10-27 19:08:35.288991	\N	\N	OPTIONS /api/api/work-orders	/api/api/work-orders	OPTIONS	127.0.0.1	404
378	2025-10-27 19:08:35.354139	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
379	2025-10-27 19:08:35.379422	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
380	2025-10-27 19:09:48.842718	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
381	2025-10-27 19:09:48.876214	\N	\N	OPTIONS /api/api/work-orders	/api/api/work-orders	OPTIONS	127.0.0.1	404
382	2025-10-27 19:09:48.883319	\N	\N	OPTIONS /api/api/work-orders	/api/api/work-orders	OPTIONS	127.0.0.1	404
383	2025-10-27 19:09:48.925092	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
384	2025-10-27 19:09:48.989773	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
385	2025-10-27 19:10:51.538604	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
389	2025-10-27 19:10:51.612842	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
393	2025-10-27 19:11:36.281076	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1261	2025-10-29 17:01:38.027666	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1264	2025-10-29 17:01:38.602562	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1268	2025-10-29 17:01:59.740286	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
1272	2025-10-29 17:02:21.447756	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1276	2025-10-29 17:02:22.231436	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1280	2025-10-29 17:02:44.408782	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
1284	2025-10-29 17:03:00.334955	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1289	2025-10-29 17:03:14.320225	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1293	2025-10-29 17:04:45.908549	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1297	2025-10-29 17:05:51.421043	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1328	2025-10-30 13:43:30.240547	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1330	2025-10-30 13:43:42.244614	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
1332	2025-10-30 13:43:44.245144	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1335	2025-10-30 13:43:44.376511	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1339	2025-10-30 13:43:44.47743	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1391	2025-10-31 11:41:57.01237	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1395	2025-10-31 11:41:57.064089	\N	\N	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	401
1399	2025-10-31 11:42:19.236453	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	401
1403	2025-10-31 11:42:37.757254	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	401
1407	2025-10-31 11:42:51.112696	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1412	2025-10-31 11:42:51.476468	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1417	2025-10-31 11:42:54.782887	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1422	2025-10-31 11:43:08.877504	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1427	2025-10-31 11:43:54.061313	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1610	2025-10-31 12:37:24.302808	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
1613	2025-10-31 12:37:35.793557	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1614	2025-10-31 12:37:35.819823	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
1617	2025-10-31 12:37:35.894586	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
1623	2025-10-31 12:38:15.677358	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1626	2025-10-31 12:38:15.746306	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1629	2025-10-31 12:38:19.551931	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1632	2025-10-31 12:38:39.968588	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1634	2025-10-31 12:38:40.053182	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
1637	2025-10-31 12:38:50.505433	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1639	2025-10-31 12:38:50.673002	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
1809	2025-10-31 16:08:37.188463	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1814	2025-10-31 16:08:37.328769	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1990	2025-10-31 16:40:05.779521	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2229	2025-10-31 18:56:31.835124	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2235	2025-10-31 18:56:31.878356	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2411	2025-11-04 16:11:06.637661	\N	\N	OPTIONS /api/suppliers	/api/suppliers	OPTIONS	127.0.0.1	200
2415	2025-11-04 16:11:17.793488	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
2421	2025-11-04 16:11:18.075164	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2558	2025-11-05 05:33:08.634484	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
2562	2025-11-05 05:33:09.173307	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
2566	2025-11-05 05:33:12.537183	\N	\N	OPTIONS /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	OPTIONS	127.0.0.1	200
2569	2025-11-05 05:33:12.606996	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
2574	2025-11-05 05:34:09.883088	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2580	2025-11-05 05:34:10.003664	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
2584	2025-11-05 05:34:25.150772	\N	\N	OPTIONS /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	OPTIONS	127.0.0.1	200
2589	2025-11-05 05:34:25.228641	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
2594	2025-11-05 05:34:35.750898	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2598	2025-11-05 05:34:35.79292	1	1	GET /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	GET	127.0.0.1	200
2603	2025-11-05 05:34:59.120503	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2607	2025-11-05 05:34:59.172442	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
2612	2025-11-05 05:35:11.626862	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
2617	2025-11-05 05:35:11.695159	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
2763	2025-11-05 15:35:32.177191	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
2764	2025-11-05 15:35:32.230502	\N	\N	OPTIONS /api/supplier-items	/api/supplier-items	OPTIONS	127.0.0.1	200
2765	2025-11-05 15:35:32.24205	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2767	2025-11-05 15:35:32.268315	1	1	GET /api/supplier-items	/api/supplier-items	GET	127.0.0.1	200
2771	2025-11-05 15:35:45.434363	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2773	2025-11-05 15:35:45.52037	\N	\N	OPTIONS /api/supplier-items	/api/supplier-items	OPTIONS	127.0.0.1	200
2778	2025-11-05 15:35:45.699227	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2782	2025-11-05 15:36:09.597365	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
2786	2025-11-05 15:36:09.687474	\N	\N	OPTIONS /api/suppliers	/api/suppliers	OPTIONS	127.0.0.1	200
2789	2025-11-05 15:36:09.778788	1	1	GET /api/suppliers	/api/suppliers	GET	127.0.0.1	200
386	2025-10-27 19:10:51.547013	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
390	2025-10-27 19:11:36.233931	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
394	2025-10-27 19:11:36.319552	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1262	2025-10-29 17:01:38.325121	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
1266	2025-10-29 17:01:59.695518	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1270	2025-10-29 17:01:59.829572	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1274	2025-10-29 17:02:21.520021	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
1278	2025-10-29 17:02:44.399494	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1282	2025-10-29 17:02:44.897892	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1286	2025-10-29 17:03:14.181195	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1288	2025-10-29 17:03:14.306426	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1292	2025-10-29 17:04:45.870499	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
1296	2025-10-29 17:05:51.324957	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
1336	2025-10-30 13:43:44.402832	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
1340	2025-10-30 13:43:44.521149	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1392	2025-10-31 11:41:57.03545	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
1396	2025-10-31 11:41:57.067627	\N	\N	GET /api/menu	/api/menu	GET	127.0.0.1	401
1400	2025-10-31 11:42:26.28877	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
1404	2025-10-31 11:42:49.320922	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
1408	2025-10-31 11:42:51.112696	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
1411	2025-10-31 11:42:51.462346	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1416	2025-10-31 11:42:54.701003	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1421	2025-10-31 11:43:08.262275	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1426	2025-10-31 11:43:13.149468	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1627	2025-10-31 12:38:15.914522	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
1630	2025-10-31 12:38:19.577929	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1642	2025-10-31 12:38:50.719171	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
1810	2025-10-31 16:08:37.193462	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1816	2025-10-31 16:08:37.339777	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1991	2025-10-31 16:48:09.606491	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
1995	2025-10-31 16:48:09.732075	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1999	2025-10-31 16:48:18.406744	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
2002	2025-10-31 16:48:18.469086	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
2006	2025-10-31 16:48:24.3655	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2010	2025-10-31 16:51:34.470295	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2014	2025-10-31 16:51:37.106889	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2017	2025-10-31 16:51:37.185239	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
2021	2025-10-31 16:51:37.972224	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
2025	2025-10-31 16:51:38.059805	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
2230	2025-10-31 18:56:31.841135	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2234	2025-10-31 18:56:31.877355	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2238	2025-10-31 18:56:52.343268	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2412	2025-11-04 16:11:06.937552	\N	\N	GET /api/suppliers	/api/suppliers	GET	127.0.0.1	401
2416	2025-11-04 16:11:17.815701	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
2422	2025-11-04 16:11:18.089705	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
2559	2025-11-05 05:33:08.765134	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
2564	2025-11-05 05:33:09.354327	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
2568	2025-11-05 05:33:12.584523	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
2572	2025-11-05 05:34:09.835608	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
2576	2025-11-05 05:34:09.942956	\N	\N	OPTIONS /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	OPTIONS	127.0.0.1	200
2578	2025-11-05 05:34:09.972454	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
2582	2025-11-05 05:34:25.141462	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
2587	2025-11-05 05:34:25.195054	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2591	2025-11-05 05:34:35.711141	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2595	2025-11-05 05:34:35.753921	\N	\N	OPTIONS /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	OPTIONS	127.0.0.1	200
2599	2025-11-05 05:34:35.798457	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
2604	2025-11-05 05:34:59.138907	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
2608	2025-11-05 05:34:59.182095	1	1	GET /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	GET	127.0.0.1	200
2613	2025-11-05 05:35:11.642976	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2620	2025-11-05 05:35:11.764928	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
2768	2025-11-05 15:35:32.429187	\N	\N	OPTIONS /api/suppliers	/api/suppliers	OPTIONS	127.0.0.1	200
2772	2025-11-05 15:35:45.438557	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
2774	2025-11-05 15:35:45.522367	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2775	2025-11-05 15:35:45.541499	\N	\N	OPTIONS /api/suppliers	/api/suppliers	OPTIONS	127.0.0.1	200
2779	2025-11-05 15:35:45.716882	1	1	GET /api/supplier-items	/api/supplier-items	GET	127.0.0.1	200
2784	2025-11-05 15:36:09.678628	\N	\N	OPTIONS /api/supplier-items	/api/supplier-items	OPTIONS	127.0.0.1	200
2788	2025-11-05 15:36:09.766194	1	1	GET /api/supplier-items	/api/supplier-items	GET	127.0.0.1	200
2792	2025-11-05 15:37:05.820053	1	1	GET /api/suppliers	/api/suppliers	GET	127.0.0.1	200
2877	2025-11-05 16:15:29.906172	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2883	2025-11-05 16:15:30.569659	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
387	2025-10-27 19:10:51.583618	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
391	2025-10-27 19:11:36.273532	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1265	2025-10-29 17:01:38.905514	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1269	2025-10-29 17:01:59.786268	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1273	2025-10-29 17:02:21.499342	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1277	2025-10-29 17:02:22.245771	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1281	2025-10-29 17:02:44.824411	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1285	2025-10-29 17:03:00.502373	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1290	2025-10-29 17:03:14.325782	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1294	2025-10-29 17:04:48.115486	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1298	2025-10-29 17:05:56.99155	\N	\N	OPTIONS /api/product-warehouses	/api/product-warehouses	OPTIONS	127.0.0.1	200
1337	2025-10-30 13:43:44.424518	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1394	2025-10-31 11:41:57.043996	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1398	2025-10-31 11:42:17.097267	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	401
1402	2025-10-31 11:42:37.746394	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
1406	2025-10-31 11:42:51.109372	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1410	2025-10-31 11:42:51.122554	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1413	2025-10-31 11:42:51.492182	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1418	2025-10-31 11:43:02.44547	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1423	2025-10-31 11:43:08.933602	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1428	2025-10-31 11:43:54.165314	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1643	2025-10-31 13:37:23.398241	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	401
1811	2025-10-31 16:08:37.197622	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1813	2025-10-31 16:08:37.291989	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1992	2025-10-31 16:48:09.631839	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1994	2025-10-31 16:48:09.715079	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
1998	2025-10-31 16:48:18.336751	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2001	2025-10-31 16:48:18.449711	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2005	2025-10-31 16:48:24.217434	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2009	2025-10-31 16:51:34.467284	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2013	2025-10-31 16:51:37.102873	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
2018	2025-10-31 16:51:37.213862	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2022	2025-10-31 16:51:37.978089	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
2231	2025-10-31 18:56:31.842135	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
2233	2025-10-31 18:56:31.868173	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
2237	2025-10-31 18:56:52.145702	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2413	2025-11-04 16:11:15.650309	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
2418	2025-11-04 16:11:17.898402	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
2590	2025-11-05 05:34:25.323114	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
2597	2025-11-05 05:34:35.78688	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
2602	2025-11-05 05:34:59.093161	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
2610	2025-11-05 05:34:59.210179	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
2615	2025-11-05 05:35:11.691159	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
2619	2025-11-05 05:35:11.745086	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
2769	2025-11-05 15:35:32.474194	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2777	2025-11-05 15:35:45.550061	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2781	2025-11-05 15:36:09.441086	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2785	2025-11-05 15:36:09.682814	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2790	2025-11-05 15:36:09.787204	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2887	2025-11-05 16:15:32.990358	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2891	2025-11-05 16:15:35.007998	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
2893	2025-11-05 16:15:35.09928	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
2899	2025-11-05 16:15:38.552072	1	1	GET /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	GET	127.0.0.1	200
2902	2025-11-05 16:15:38.604464	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
2907	2025-11-05 16:15:56.255551	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
2910	2025-11-05 16:15:56.334017	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
2915	2025-11-05 16:15:57.386909	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
2920	2025-11-05 16:15:57.482765	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
2969	2025-11-05 16:44:25.239034	1	1	POST /api/reports/nl	/api/reports/nl	POST	127.0.0.1	200
3018	2025-11-05 18:19:41.057281	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
3048	2025-11-05 19:28:45.166746	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
3050	2025-11-05 19:28:46.881508	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
3053	2025-11-05 19:28:46.962586	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
3057	2025-11-05 19:28:47.294607	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3061	2025-11-05 19:28:59.095405	1	1	REPORT_NL ok=True rows=10 err=	/api/reports/nl	POST	127.0.0.1	\N
3065	2025-11-05 19:30:01.674311	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
3093	2025-11-05 19:47:51.090638	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3098	2025-11-05 19:49:51.275556	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
3103	2025-11-05 19:50:24.048022	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
3111	2025-11-05 20:12:01.343086	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
3114	2025-11-05 20:12:24.63288	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3117	2025-11-05 20:12:24.778308	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
388	2025-10-27 19:10:51.60984	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
392	2025-10-27 19:11:36.27637	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
395	2025-10-27 19:14:13.905751	\N	\N	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	401
396	2025-10-27 19:14:13.92161	\N	\N	GET /api/dashboard/alerts	/api/dashboard/alerts	GET	127.0.0.1	401
397	2025-10-27 19:14:13.92161	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
398	2025-10-27 19:14:37.713967	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
399	2025-10-27 19:14:37.95921	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
400	2025-10-27 19:14:39.565011	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
401	2025-10-27 19:14:39.566013	\N	\N	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	401
402	2025-10-27 19:14:39.569147	\N	\N	GET /api/dashboard/alerts	/api/dashboard/alerts	GET	127.0.0.1	401
403	2025-10-27 19:14:39.57218	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
404	2025-10-27 19:14:39.635633	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
405	2025-10-27 19:14:39.666643	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
406	2025-10-27 19:15:03.995244	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
407	2025-10-27 19:15:04.016751	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
408	2025-10-27 19:15:11.445348	\N	\N	OPTIONS /api/producto-almacen/listado/todos	/api/producto-almacen/listado/todos	OPTIONS	127.0.0.1	404
409	2025-10-27 19:15:32.7243	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
410	2025-10-27 19:15:32.793085	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
411	2025-10-27 19:15:34.435645	\N	\N	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	401
412	2025-10-27 19:15:44.159571	\N	\N	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	401
413	2025-10-27 19:15:53.548464	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
414	2025-10-27 19:15:53.551879	\N	\N	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	401
415	2025-10-27 19:15:53.558658	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
416	2025-10-27 19:15:53.587807	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
417	2025-10-27 19:15:57.035863	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
418	2025-10-27 19:15:57.055486	\N	\N	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	401
419	2025-10-27 19:15:57.065783	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
420	2025-10-27 19:15:59.128221	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
421	2025-10-27 19:15:59.130864	\N	\N	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	401
422	2025-10-27 19:15:59.139515	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
423	2025-10-27 19:15:59.235721	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
424	2025-10-27 19:16:01.011577	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
425	2025-10-27 19:16:01.013022	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
426	2025-10-27 19:16:15.530571	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
427	2025-10-27 19:16:15.537847	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
428	2025-10-27 19:16:15.547505	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
429	2025-10-27 19:16:15.603854	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
430	2025-10-27 19:16:15.6143	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
431	2025-10-27 19:16:24.185173	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
432	2025-10-27 19:16:24.187905	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
433	2025-10-27 19:16:24.191144	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
434	2025-10-27 19:16:24.195343	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
435	2025-10-27 19:16:24.274627	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
436	2025-10-27 19:16:24.277552	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
437	2025-10-27 19:16:24.29499	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
438	2025-10-27 19:16:36.599303	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
439	2025-10-27 19:16:36.619269	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
440	2025-10-27 19:16:36.623286	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
441	2025-10-27 19:16:36.667852	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
442	2025-10-27 19:16:36.668866	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
443	2025-10-27 19:16:36.697487	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
444	2025-10-27 19:16:36.721544	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
445	2025-10-27 19:16:36.734788	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
446	2025-10-27 19:16:36.744958	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
447	2025-10-27 19:16:36.831697	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
448	2025-10-27 19:16:40.627269	\N	\N	OPTIONS /api/supplier-items	/api/supplier-items	OPTIONS	127.0.0.1	200
449	2025-10-27 19:16:40.636841	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
450	2025-10-27 19:16:40.640709	\N	\N	OPTIONS /api/suppliers	/api/suppliers	OPTIONS	127.0.0.1	200
451	2025-10-27 19:16:40.671771	1	1	GET /api/supplier-items	/api/supplier-items	GET	127.0.0.1	200
452	2025-10-27 19:16:40.678839	1	1	GET /api/suppliers	/api/suppliers	GET	127.0.0.1	200
453	2025-10-27 19:16:40.69145	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
454	2025-10-27 19:16:58.304796	\N	\N	OPTIONS /api/suppliers	/api/suppliers	OPTIONS	127.0.0.1	200
455	2025-10-27 19:16:58.354287	1	1	GET /api/suppliers	/api/suppliers	GET	127.0.0.1	200
456	2025-10-27 19:17:21.774437	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
457	2025-10-27 19:17:31.013514	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	404
458	2025-10-27 19:40:19.436133	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
459	2025-10-27 19:40:19.539453	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
460	2025-10-27 19:40:19.549876	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
461	2025-10-27 19:40:19.582663	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
462	2025-10-27 19:42:13.87503	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
463	2025-10-27 19:42:13.921884	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
464	2025-10-27 19:42:13.924415	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
467	2025-10-27 19:42:44.479828	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
470	2025-10-27 19:42:44.710597	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
473	2025-10-27 19:43:11.253986	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
476	2025-10-27 19:43:50.468978	\N	\N	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	401
1300	2025-10-29 17:09:00.161259	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1338	2025-10-30 13:43:44.441823	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1415	2025-10-31 11:42:51.637445	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1420	2025-10-31 11:43:08.205584	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
1425	2025-10-31 11:43:11.037911	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1430	2025-10-31 11:43:54.431934	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1644	2025-10-31 13:38:01.18863	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
1645	2025-10-31 13:38:03.257229	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
1646	2025-10-31 13:38:09.382626	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
1812	2025-10-31 16:08:37.202614	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1815	2025-10-31 16:08:37.336778	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1993	2025-10-31 16:48:09.638989	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
1997	2025-10-31 16:48:18.330724	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2003	2025-10-31 16:48:18.475549	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2007	2025-10-31 16:51:11.585902	\N	\N	OPTIONS /api/movements	/api/movements	OPTIONS	127.0.0.1	200
2011	2025-10-31 16:51:34.585222	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2015	2025-10-31 16:51:37.113633	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
2019	2025-10-31 16:51:37.945312	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2024	2025-10-31 16:51:38.034355	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2232	2025-10-31 18:56:31.84538	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
2236	2025-10-31 18:56:31.897311	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
2414	2025-11-04 16:11:16.021008	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
2417	2025-11-04 16:11:17.884835	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
2423	2025-11-04 16:11:18.223846	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2606	2025-11-05 05:34:59.159214	\N	\N	OPTIONS /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	OPTIONS	127.0.0.1	200
2611	2025-11-05 05:35:11.616619	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2616	2025-11-05 05:35:11.694157	\N	\N	OPTIONS /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	OPTIONS	127.0.0.1	200
2791	2025-11-05 15:37:05.706007	\N	\N	OPTIONS /api/suppliers	/api/suppliers	OPTIONS	127.0.0.1	200
2904	2025-11-05 16:15:38.716571	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
2909	2025-11-05 16:15:56.263977	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
2914	2025-11-05 16:15:57.381587	\N	\N	OPTIONS /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	OPTIONS	127.0.0.1	200
2918	2025-11-05 16:15:57.455368	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
2923	2025-11-05 16:16:17.129508	\N	\N	OPTIONS /api/reports/nl	/api/reports/nl	OPTIONS	127.0.0.1	200
2970	2025-11-05 16:45:12.420305	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
2971	2025-11-05 16:45:17.888664	1	1	REPORT_NL ok=True rows=3 err=	/api/reports/nl	POST	127.0.0.1	\N
2973	2025-11-05 16:45:23.854962	1	1	REPORT_NL ok=True rows=3 err=	/api/reports/nl	POST	127.0.0.1	\N
2975	2025-11-05 16:45:31.027053	1	1	REPORT_NL ok=True rows=0 err=	/api/reports/nl	POST	127.0.0.1	\N
2977	2025-11-05 16:45:35.886254	1	1	REPORT_NL ok=True rows=3 err=	/api/reports/nl	POST	127.0.0.1	\N
3020	2025-11-05 18:19:41.248285	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3049	2025-11-05 19:28:46.868472	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
3054	2025-11-05 19:28:46.977889	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
3059	2025-11-05 19:28:50.914936	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3064	2025-11-05 19:30:01.394752	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
3094	2025-11-05 19:47:51.232746	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3099	2025-11-05 19:50:16.984497	\N	\N	OPTIONS /api/movements	/api/movements	OPTIONS	127.0.0.1	200
3104	2025-11-05 19:50:24.103964	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
3120	2025-11-07 10:16:57.476766	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
3121	2025-11-07 10:17:10.395445	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
3122	2025-11-07 10:17:25.257193	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3123	2025-11-07 10:17:25.270029	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
3124	2025-11-07 10:17:25.377305	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
3127	2025-11-07 10:17:26.345673	\N	\N	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	401
3130	2025-11-07 10:17:37.323106	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3132	2025-11-07 10:17:37.437055	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
3134	2025-11-07 10:17:37.462949	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3139	2025-11-07 10:17:38.340107	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
3142	2025-11-07 10:17:45.208698	\N	\N	OPTIONS /api/movements	/api/movements	OPTIONS	127.0.0.1	200
3145	2025-11-07 10:18:18.93147	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
3148	2025-11-07 10:18:49.507754	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
3151	2025-11-07 10:18:52.492027	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
3153	2025-11-07 10:18:56.545446	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3155	2025-11-07 10:18:56.589259	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3158	2025-11-07 10:18:58.572836	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
3160	2025-11-07 10:18:58.62694	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
3163	2025-11-07 10:19:08.682991	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
465	2025-10-27 19:42:13.98544	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
468	2025-10-27 19:42:44.616183	\N	\N	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	401
471	2025-10-27 19:42:44.784112	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
474	2025-10-27 19:43:13.249483	\N	\N	OPTIONS /api/producto-almacen/listado/todos	/api/producto-almacen/listado/todos	OPTIONS	127.0.0.1	404
477	2025-10-27 19:44:22.200371	\N	\N	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	401
479	2025-10-27 19:44:59.30769	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1301	2025-10-29 17:09:00.343249	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1342	2025-10-30 18:09:06.099704	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
1343	2025-10-30 18:09:06.352603	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
1344	2025-10-30 18:09:07.916059	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1345	2025-10-30 18:09:07.921815	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
1346	2025-10-30 18:09:07.983645	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1347	2025-10-30 18:09:08.004023	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1349	2025-10-30 18:09:08.147486	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1431	2025-10-31 11:51:49.25247	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
1434	2025-10-31 11:51:49.369481	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1439	2025-10-31 11:51:57.817168	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1444	2025-10-31 11:53:33.368451	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1449	2025-10-31 11:53:38.362349	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1454	2025-10-31 11:53:48.230332	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1459	2025-10-31 11:54:06.365656	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1464	2025-10-31 11:54:26.742681	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1469	2025-10-31 11:55:09.727652	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1474	2025-10-31 11:55:13.75938	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1647	2025-10-31 13:40:27.961493	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
1648	2025-10-31 13:40:30.038473	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
1649	2025-10-31 13:40:32.113216	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1650	2025-10-31 13:40:34.170033	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1651	2025-10-31 13:40:36.231222	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
1817	2025-10-31 16:09:32.427739	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
1818	2025-10-31 16:09:32.571423	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
1821	2025-10-31 16:09:32.676861	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
1823	2025-10-31 16:11:02.199556	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1827	2025-10-31 16:11:02.295655	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1830	2025-10-31 16:11:02.354658	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
1833	2025-10-31 16:11:10.211255	\N	\N	OPTIONS /api/movements	/api/movements	OPTIONS	127.0.0.1	200
1836	2025-10-31 16:14:00.239463	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1839	2025-10-31 16:14:00.336795	\N	\N	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	401
1996	2025-10-31 16:48:09.868259	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
2000	2025-10-31 16:48:18.410742	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
2004	2025-10-31 16:48:18.527633	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
2008	2025-10-31 16:51:11.665521	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
2012	2025-10-31 16:51:34.599688	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2016	2025-10-31 16:51:37.168878	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
2020	2025-10-31 16:51:37.969219	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2023	2025-10-31 16:51:38.026355	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
2239	2025-10-31 18:58:43.868157	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2243	2025-10-31 18:59:58.69981	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2247	2025-10-31 18:59:58.717424	\N	\N	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	401
2251	2025-10-31 19:00:14.486854	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
2255	2025-10-31 19:00:16.21411	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
2260	2025-10-31 19:00:16.285862	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
2263	2025-10-31 19:00:19.064754	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
2267	2025-10-31 19:00:20.05315	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2273	2025-10-31 19:00:20.106386	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2277	2025-10-31 19:01:08.445138	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2281	2025-10-31 19:01:18.457644	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2419	2025-11-04 16:11:17.928455	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2621	2025-11-05 05:44:26.200709	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2625	2025-11-05 05:44:26.307892	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
2630	2025-11-05 05:44:36.168935	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2635	2025-11-05 05:44:51.715524	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
2640	2025-11-05 05:46:52.312555	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
2645	2025-11-05 05:46:52.386567	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
2793	2025-11-05 15:40:58.072487	\N	\N	OPTIONS /api/suppliers	/api/suppliers	OPTIONS	127.0.0.1	200
2796	2025-11-05 15:40:58.310645	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
2919	2025-11-05 16:15:57.464392	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2972	2025-11-05 16:45:20.714345	1	1	POST /api/reports/nl	/api/reports/nl	POST	127.0.0.1	200
2974	2025-11-05 16:45:26.135913	1	1	POST /api/reports/nl	/api/reports/nl	POST	127.0.0.1	200
2976	2025-11-05 16:45:32.418592	1	1	POST /api/reports/nl	/api/reports/nl	POST	127.0.0.1	200
2978	2025-11-05 16:45:37.873533	1	1	POST /api/reports/nl	/api/reports/nl	POST	127.0.0.1	200
3021	2025-11-05 18:19:41.257215	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
466	2025-10-27 19:42:44.194602	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
469	2025-10-27 19:42:44.620394	\N	\N	GET /api/dashboard/alerts	/api/dashboard/alerts	GET	127.0.0.1	401
472	2025-10-27 19:43:11.226837	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
475	2025-10-27 19:43:28.231309	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
478	2025-10-27 19:44:59.287359	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
480	2025-10-27 19:44:59.356647	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
481	2025-10-27 19:44:59.529785	\N	\N	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	401
482	2025-10-27 19:45:31.036472	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
483	2025-10-27 19:45:51.536228	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
484	2025-10-27 19:45:51.677098	\N	\N	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	401
485	2025-10-27 19:45:51.691693	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
486	2025-10-27 19:45:51.779972	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
487	2025-10-27 19:45:52.022938	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
488	2025-10-27 19:46:02.025965	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
489	2025-10-27 19:46:06.229215	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
490	2025-10-27 19:46:08.306792	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
491	2025-10-27 19:46:37.320847	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
492	2025-10-27 19:46:39.392376	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
493	2025-10-27 19:46:41.448919	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
494	2025-10-27 19:46:43.517899	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
495	2025-10-27 19:47:07.271288	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
496	2025-10-27 19:47:15.539722	\N	\N	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	401
497	2025-10-27 19:47:36.291411	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
498	2025-10-27 19:47:36.426268	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
499	2025-10-27 19:47:36.495662	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
500	2025-10-27 19:48:34.675062	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
501	2025-10-27 19:48:36.686974	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
502	2025-10-27 19:48:38.753064	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
503	2025-10-27 19:48:40.770395	\N	\N	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	401
504	2025-10-27 19:48:42.844525	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
505	2025-10-27 19:49:52.702623	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
506	2025-10-27 19:49:52.718948	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
507	2025-10-27 19:49:52.723463	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
508	2025-10-27 19:49:52.729672	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
509	2025-10-27 19:49:52.97679	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
510	2025-10-27 19:49:53.082148	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
511	2025-10-27 19:50:08.942408	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
512	2025-10-27 19:50:09.571434	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
513	2025-10-27 19:50:09.58045	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
514	2025-10-27 19:50:09.585327	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
515	2025-10-27 19:50:09.673374	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
516	2025-10-27 19:50:09.694289	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
517	2025-10-27 19:53:16.306864	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
518	2025-10-27 19:53:31.028321	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
519	2025-10-27 19:53:31.043309	\N	\N	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	401
520	2025-10-27 19:53:31.057985	\N	\N	GET /api/dashboard/alerts	/api/dashboard/alerts	GET	127.0.0.1	401
521	2025-10-27 19:53:31.108248	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
522	2025-10-27 19:53:31.180215	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
523	2025-10-27 19:53:31.524655	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
524	2025-10-27 19:56:16.455105	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
525	2025-10-27 19:56:18.538142	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
526	2025-10-27 19:57:13.488978	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
527	2025-10-27 19:57:13.49996	\N	\N	GET /api/dashboard/alerts	/api/dashboard/alerts	GET	127.0.0.1	401
528	2025-10-27 19:57:13.520545	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
529	2025-10-27 19:57:13.615283	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
530	2025-10-27 19:57:13.633492	\N	\N	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	401
531	2025-10-27 19:57:13.741272	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
532	2025-10-27 19:57:32.330489	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
533	2025-10-27 19:57:32.340063	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
534	2025-10-27 19:57:32.347981	\N	\N	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	401
535	2025-10-27 19:57:32.354518	\N	\N	GET /api/dashboard/alerts	/api/dashboard/alerts	GET	127.0.0.1	401
536	2025-10-27 19:57:32.565657	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
537	2025-10-27 19:57:32.689056	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
538	2025-10-27 19:59:22.721301	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
539	2025-10-27 19:59:22.964695	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
540	2025-10-27 19:59:24.701906	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
541	2025-10-27 19:59:24.710094	\N	\N	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	401
542	2025-10-27 19:59:24.723834	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
543	2025-10-27 19:59:24.787048	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
544	2025-10-27 19:59:24.812806	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
545	2025-10-27 19:59:24.816726	\N	\N	GET /api/dashboard/alerts	/api/dashboard/alerts	GET	127.0.0.1	401
546	2025-10-27 19:59:34.914105	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
549	2025-10-27 20:00:35.269703	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
552	2025-10-27 20:00:48.94551	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
555	2025-10-27 20:01:11.373801	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
558	2025-10-27 20:01:11.48599	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
561	2025-10-27 20:01:19.993725	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
564	2025-10-27 20:02:11.380075	\N	\N	GET /api/menu	/api/menu	GET	127.0.0.1	401
567	2025-10-27 20:02:43.390008	\N	\N	GET /api/menu	/api/menu	GET	127.0.0.1	401
570	2025-10-27 20:03:17.192241	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
1302	2025-10-29 17:09:04.963333	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1348	2025-10-30 18:09:08.036759	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1352	2025-10-30 18:09:08.311295	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1432	2025-10-31 11:51:49.255583	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1437	2025-10-31 11:51:55.237038	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1442	2025-10-31 11:51:59.224437	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1447	2025-10-31 11:53:36.540975	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1452	2025-10-31 11:53:46.804008	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
1457	2025-10-31 11:53:50.090781	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1462	2025-10-31 11:54:25.242981	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1467	2025-10-31 11:54:59.221739	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1472	2025-10-31 11:55:10.982333	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1652	2025-10-31 15:05:27.04963	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1653	2025-10-31 15:05:27.065662	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1654	2025-10-31 15:05:27.155352	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
1655	2025-10-31 15:05:27.166348	\N	\N	GET /api/products	/api/products	GET	127.0.0.1	401
1660	2025-10-31 15:05:27.559344	\N	\N	GET /api/menu	/api/menu	GET	127.0.0.1	401
1819	2025-10-31 16:09:32.595568	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
1822	2025-10-31 16:09:32.702531	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1824	2025-10-31 16:11:02.201807	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1826	2025-10-31 16:11:02.293652	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1829	2025-10-31 16:11:02.32036	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
1831	2025-10-31 16:11:02.365599	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
1834	2025-10-31 16:11:10.263236	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
1837	2025-10-31 16:14:00.242102	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1840	2025-10-31 16:14:20.166128	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
1842	2025-10-31 16:14:22.322284	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1843	2025-10-31 16:14:22.407049	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
1845	2025-10-31 16:14:22.487889	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
1849	2025-10-31 16:14:22.653369	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1852	2025-10-31 16:14:27.746035	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1856	2025-10-31 16:14:27.887135	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1860	2025-10-31 16:14:30.853857	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2026	2025-10-31 17:57:31.56486	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2030	2025-10-31 17:58:17.361683	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2034	2025-10-31 17:58:17.414817	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
2037	2025-10-31 17:58:17.457943	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
2040	2025-10-31 17:58:29.559971	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
2044	2025-10-31 17:58:29.6004	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
2048	2025-10-31 17:58:31.129386	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
2240	2025-10-31 18:58:43.872158	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2244	2025-10-31 18:59:58.701824	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2248	2025-10-31 18:59:58.720413	\N	\N	GET /api/products	/api/products	GET	127.0.0.1	401
2252	2025-10-31 19:00:14.646168	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
2256	2025-10-31 19:00:16.218596	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
2259	2025-10-31 19:00:16.265737	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
2262	2025-10-31 19:00:19.048473	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2266	2025-10-31 19:00:19.090001	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2270	2025-10-31 19:00:20.06362	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
2274	2025-10-31 19:00:20.119113	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
2278	2025-10-31 19:01:08.46439	1	1	POST /api/work-orders	/api/work-orders	POST	127.0.0.1	400
2282	2025-10-31 19:01:18.49313	1	1	POST /api/work-orders	/api/work-orders	POST	127.0.0.1	400
2420	2025-11-04 16:11:17.952589	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
2622	2025-11-05 05:44:26.260551	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
2627	2025-11-05 05:44:26.36875	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
2631	2025-11-05 05:44:36.203358	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2636	2025-11-05 05:44:51.736694	1	1	GET /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	GET	127.0.0.1	200
2641	2025-11-05 05:46:52.357689	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2646	2025-11-05 05:46:52.606131	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
2794	2025-11-05 15:40:58.114092	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
2797	2025-11-05 15:40:58.376116	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2924	2025-11-05 16:17:19.839783	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	401
547	2025-10-27 20:00:35.246053	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
550	2025-10-27 20:00:35.518835	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
553	2025-10-27 20:00:49.077672	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
556	2025-10-27 20:01:11.377883	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
559	2025-10-27 20:01:19.987064	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
562	2025-10-27 20:02:11.373332	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
565	2025-10-27 20:02:43.379025	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
568	2025-10-27 20:03:17.159166	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
1303	2025-10-29 17:09:05.17182	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1350	2025-10-30 18:09:08.189765	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1433	2025-10-31 11:51:49.269261	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1438	2025-10-31 11:51:55.293437	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1443	2025-10-31 11:53:33.326374	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
1448	2025-10-31 11:53:38.331632	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
1453	2025-10-31 11:53:46.847776	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1458	2025-10-31 11:54:06.307781	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1463	2025-10-31 11:54:26.148652	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1468	2025-10-31 11:54:59.258413	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1473	2025-10-31 11:55:13.724878	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1656	2025-10-31 15:05:27.253568	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1661	2025-10-31 15:05:27.563464	\N	\N	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	401
1820	2025-10-31 16:09:32.615734	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1825	2025-10-31 16:11:02.221331	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
1828	2025-10-31 16:11:02.315829	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1832	2025-10-31 16:11:02.381619	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1835	2025-10-31 16:11:12.691613	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
1838	2025-10-31 16:14:00.332791	\N	\N	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	401
1841	2025-10-31 16:14:20.59239	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
1844	2025-10-31 16:14:22.423929	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1848	2025-10-31 16:14:22.622032	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1851	2025-10-31 16:14:27.73369	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1855	2025-10-31 16:14:27.864267	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1857	2025-10-31 16:14:27.920119	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1861	2025-10-31 16:14:30.859855	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2027	2025-10-31 17:57:31.665907	\N	\N	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	401
2031	2025-10-31 17:58:17.364683	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
2035	2025-10-31 17:58:17.41682	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
2041	2025-10-31 17:58:29.567971	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
2045	2025-10-31 17:58:29.621158	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
2049	2025-10-31 17:58:31.150239	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
2241	2025-10-31 18:58:43.961614	\N	\N	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2245	2025-10-31 18:59:58.705826	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
2249	2025-10-31 18:59:58.723412	\N	\N	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	401
2253	2025-10-31 19:00:16.210093	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2258	2025-10-31 19:00:16.259544	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2264	2025-10-31 19:00:19.074593	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
2268	2025-10-31 19:00:20.056288	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2272	2025-10-31 19:00:20.098152	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2276	2025-10-31 19:01:02.248967	1	1	POST /api/work-orders	/api/work-orders	POST	127.0.0.1	400
2280	2025-10-31 19:01:09.110021	1	1	POST /api/work-orders	/api/work-orders	POST	127.0.0.1	400
2424	2025-11-05 04:55:36.001498	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
2428	2025-11-05 04:55:36.083168	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
2434	2025-11-05 04:55:47.529614	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
2438	2025-11-05 04:55:49.262565	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
2444	2025-11-05 04:55:54.737559	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
2450	2025-11-05 04:56:42.1903	\N	\N	OPTIONS /api/movements	/api/movements	OPTIONS	127.0.0.1	200
2456	2025-11-05 04:57:18.797249	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
2462	2025-11-05 04:57:35.22721	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2467	2025-11-05 04:57:53.140556	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2473	2025-11-05 04:57:55.543568	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2479	2025-11-05 04:58:03.174105	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
2485	2025-11-05 04:58:18.333433	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
2496	2025-11-05 04:58:31.052764	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
2502	2025-11-05 04:58:31.37804	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
2507	2025-11-05 04:58:50.09453	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
2623	2025-11-05 05:44:26.294775	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
2626	2025-11-05 05:44:26.361017	1	1	GET /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	GET	127.0.0.1	200
2632	2025-11-05 05:44:36.209282	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2638	2025-11-05 05:44:51.764859	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
2643	2025-11-05 05:46:52.36966	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
2648	2025-11-05 05:46:52.676457	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
3359	2025-11-07 20:13:28.388781	1	1	PUT /api/users/5	/api/users/5	PUT	127.0.0.1	200
548	2025-10-27 20:00:35.266823	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
551	2025-10-27 20:00:48.94161	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
554	2025-10-27 20:00:49.246546	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
557	2025-10-27 20:01:11.406413	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
560	2025-10-27 20:01:19.989749	\N	\N	GET /api/menu	/api/menu	GET	127.0.0.1	401
563	2025-10-27 20:02:11.378585	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
566	2025-10-27 20:02:43.386913	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
569	2025-10-27 20:03:17.175537	\N	\N	GET /api/menu	/api/menu	GET	127.0.0.1	401
571	2025-10-27 20:16:07.187444	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
572	2025-10-27 20:16:07.565632	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
573	2025-10-27 20:16:11.447862	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
574	2025-10-27 20:16:11.447862	\N	\N	GET /api/menu	/api/menu	GET	127.0.0.1	401
575	2025-10-27 20:16:11.457729	\N	\N	GET /api/dashboard/alerts	/api/dashboard/alerts	GET	127.0.0.1	401
576	2025-10-27 20:16:11.571987	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
577	2025-10-27 20:16:11.580269	\N	\N	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	401
578	2025-10-27 20:17:24.015291	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
579	2025-10-27 20:17:24.017357	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
580	2025-10-27 20:17:24.020499	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
581	2025-10-27 20:17:24.025257	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
582	2025-10-27 20:17:24.025257	\N	\N	OPTIONS /api/dashboard/alerts	/api/dashboard/alerts	OPTIONS	127.0.0.1	200
583	2025-10-27 20:17:24.097995	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
584	2025-10-27 20:17:24.100903	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
585	2025-10-27 20:17:24.122522	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
586	2025-10-27 20:17:24.148822	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
587	2025-10-27 20:17:24.223126	1	1	GET /api/dashboard/alerts	/api/dashboard/alerts	GET	127.0.0.1	200
588	2025-10-27 20:18:06.246525	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
589	2025-10-27 20:18:06.248923	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
590	2025-10-27 20:18:06.253389	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
591	2025-10-27 20:18:06.314944	\N	\N	OPTIONS /api/dashboard/alerts	/api/dashboard/alerts	OPTIONS	127.0.0.1	200
592	2025-10-27 20:18:06.317211	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
593	2025-10-27 20:18:06.396848	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
594	2025-10-27 20:18:06.477955	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
595	2025-10-27 20:18:06.569199	1	1	GET /api/dashboard/alerts	/api/dashboard/alerts	GET	127.0.0.1	200
596	2025-10-27 20:18:06.596388	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
597	2025-10-27 20:18:06.635949	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
598	2025-10-27 20:18:54.297397	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
599	2025-10-27 20:18:54.308131	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
600	2025-10-27 20:18:54.316724	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
601	2025-10-27 20:18:54.322727	\N	\N	OPTIONS /api/dashboard/alerts	/api/dashboard/alerts	OPTIONS	127.0.0.1	200
602	2025-10-27 20:18:54.37254	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
603	2025-10-27 20:18:54.40247	1	1	GET /api/dashboard/alerts	/api/dashboard/alerts	GET	127.0.0.1	200
604	2025-10-27 20:18:54.406475	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
605	2025-10-27 20:18:54.440038	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
606	2025-10-27 20:18:54.497783	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
607	2025-10-27 20:19:19.581783	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
608	2025-10-27 20:19:19.585042	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
609	2025-10-27 20:19:19.591704	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
610	2025-10-27 20:19:19.605745	\N	\N	OPTIONS /api/dashboard/alerts	/api/dashboard/alerts	OPTIONS	127.0.0.1	200
611	2025-10-27 20:19:19.615204	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
612	2025-10-27 20:19:19.695778	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
613	2025-10-27 20:19:19.696411	1	1	GET /api/dashboard/alerts	/api/dashboard/alerts	GET	127.0.0.1	200
614	2025-10-27 20:19:19.729305	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
615	2025-10-27 20:19:19.737795	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
616	2025-10-27 20:19:19.753879	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
617	2025-10-27 20:19:27.549113	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
618	2025-10-27 20:19:27.578427	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
619	2025-10-27 20:20:46.585082	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
620	2025-10-27 20:20:46.594678	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
621	2025-10-27 20:20:46.618232	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
622	2025-10-27 20:20:46.638881	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
623	2025-10-27 20:20:46.659624	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
624	2025-10-27 20:21:37.657768	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
625	2025-10-27 20:21:37.657768	\N	\N	OPTIONS /api/dashboard/alerts	/api/dashboard/alerts	OPTIONS	127.0.0.1	200
626	2025-10-27 20:21:37.663374	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
627	2025-10-27 20:21:37.681166	1	1	GET /api/dashboard/alerts	/api/dashboard/alerts	GET	127.0.0.1	200
628	2025-10-27 20:21:37.731284	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
629	2025-10-27 20:21:37.842857	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
630	2025-10-27 20:21:47.017571	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
631	2025-10-27 20:21:47.038274	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
632	2025-10-27 20:21:49.408438	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
633	2025-10-27 20:21:49.47034	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
638	2025-10-27 20:22:02.048098	\N	\N	OPTIONS /api/product-warehouses	/api/product-warehouses	OPTIONS	127.0.0.1	200
643	2025-10-27 20:22:08.841168	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
651	2025-10-27 20:22:25.35257	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
655	2025-10-27 20:22:32.505312	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
658	2025-10-27 20:22:32.619371	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
661	2025-10-27 20:22:36.691021	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
665	2025-10-27 20:22:36.75861	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
670	2025-10-27 20:22:45.16233	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
673	2025-10-27 20:23:05.916311	\N	\N	OPTIONS /api/product-warehouses	/api/product-warehouses	OPTIONS	127.0.0.1	200
678	2025-10-27 20:23:15.374019	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
683	2025-10-27 20:23:29.128576	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
687	2025-10-27 20:23:34.348008	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
692	2025-10-27 20:23:45.058758	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
697	2025-10-27 20:23:45.189797	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
701	2025-10-27 20:24:08.528249	1	1	GET /api/dashboard/alerts	/api/dashboard/alerts	GET	127.0.0.1	200
705	2025-10-27 20:24:19.382566	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
710	2025-10-27 20:24:19.450873	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
715	2025-10-27 20:24:38.840011	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
720	2025-10-27 20:25:22.021977	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
725	2025-10-27 20:25:31.948849	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
730	2025-10-27 20:25:43.270455	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1304	2025-10-29 17:40:55.734792	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
1306	2025-10-29 17:41:00.830337	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1310	2025-10-29 17:41:01.157092	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
1317	2025-10-29 17:41:49.324368	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1321	2025-10-29 17:41:53.81143	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1324	2025-10-29 17:42:15.630249	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1351	2025-10-30 18:09:08.214127	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
1435	2025-10-31 11:51:49.536673	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1440	2025-10-31 11:51:57.850506	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1445	2025-10-31 11:53:34.872667	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1450	2025-10-31 11:53:40.308594	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1455	2025-10-31 11:53:48.90323	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1460	2025-10-31 11:54:08.760752	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1465	2025-10-31 11:54:27.388143	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1470	2025-10-31 11:55:09.767002	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1657	2025-10-31 15:05:27.26566	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1662	2025-10-31 15:05:27.569323	\N	\N	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	401
1846	2025-10-31 16:14:22.547142	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1850	2025-10-31 16:14:22.754749	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1853	2025-10-31 16:14:27.754052	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
1858	2025-10-31 16:14:27.929553	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
1863	2025-10-31 16:14:30.935556	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1865	2025-10-31 16:14:57.819815	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
1868	2025-10-31 16:14:58.03954	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1872	2025-10-31 16:16:01.383099	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1876	2025-10-31 16:16:01.474393	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
2028	2025-10-31 17:58:15.562223	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
2033	2025-10-31 17:58:17.395285	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2038	2025-10-31 17:58:17.466994	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
2043	2025-10-31 17:58:29.579404	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2046	2025-10-31 17:58:29.627697	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2050	2025-10-31 17:58:42.465501	\N	\N	OPTIONS /api/movements	/api/movements	OPTIONS	127.0.0.1	200
2242	2025-10-31 18:58:43.972372	\N	\N	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2246	2025-10-31 18:59:58.705826	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
2250	2025-10-31 18:59:58.752525	\N	\N	GET /api/users	/api/users	GET	127.0.0.1	200
2254	2025-10-31 19:00:16.212107	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
2257	2025-10-31 19:00:16.254286	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
2261	2025-10-31 19:00:16.299027	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2265	2025-10-31 19:00:19.077593	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
2269	2025-10-31 19:00:20.06362	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
2271	2025-10-31 19:00:20.088488	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
2275	2025-10-31 19:01:02.230088	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2279	2025-10-31 19:01:08.92314	1	1	POST /api/work-orders	/api/work-orders	POST	127.0.0.1	400
2283	2025-10-31 19:01:20.695864	1	1	POST /api/work-orders	/api/work-orders	POST	127.0.0.1	400
2425	2025-11-05 04:55:36.002516	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
2430	2025-11-05 04:55:36.253545	\N	\N	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	401
2436	2025-11-05 04:55:49.227481	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
2443	2025-11-05 04:55:49.4567	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
634	2025-10-27 20:21:51.567938	\N	\N	OPTIONS /api/product-warehouses	/api/product-warehouses	OPTIONS	127.0.0.1	200
639	2025-10-27 20:22:02.078923	1	1	GET /api/product-warehouses	/api/product-warehouses	GET	127.0.0.1	200
644	2025-10-27 20:22:12.950057	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
648	2025-10-27 20:22:16.276948	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
656	2025-10-27 20:22:32.507036	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
660	2025-10-27 20:22:32.708774	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
663	2025-10-27 20:22:36.727159	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
668	2025-10-27 20:22:43.046401	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
676	2025-10-27 20:23:09.954512	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
681	2025-10-27 20:23:29.120403	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
685	2025-10-27 20:23:29.270916	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
689	2025-10-27 20:23:34.381225	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
694	2025-10-27 20:23:45.118666	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
699	2025-10-27 20:24:08.438495	\N	\N	OPTIONS /api/dashboard/alerts	/api/dashboard/alerts	OPTIONS	127.0.0.1	200
708	2025-10-27 20:24:19.419068	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
714	2025-10-27 20:24:20.501465	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
719	2025-10-27 20:25:21.99706	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
724	2025-10-27 20:25:31.90447	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
729	2025-10-27 20:25:43.254132	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1305	2025-10-29 17:40:55.96006	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1307	2025-10-29 17:41:00.994404	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1311	2025-10-29 17:41:01.171309	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1314	2025-10-29 17:41:49.278412	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1318	2025-10-29 17:41:49.385256	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1322	2025-10-29 17:41:53.818527	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1325	2025-10-29 17:42:15.662087	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1353	2025-10-30 18:09:18.293753	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1354	2025-10-30 18:09:18.312188	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1355	2025-10-30 18:09:22.378963	\N	\N	OPTIONS /api/product-warehouses	/api/product-warehouses	OPTIONS	127.0.0.1	200
1356	2025-10-30 18:09:22.447853	1	1	GET /api/product-warehouses	/api/product-warehouses	GET	127.0.0.1	200
1357	2025-10-30 18:09:24.933841	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1358	2025-10-30 18:09:24.952803	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1359	2025-10-30 18:09:27.293838	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1360	2025-10-30 18:09:27.312817	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1361	2025-10-30 18:09:29.627163	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1362	2025-10-30 18:09:30.300521	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1363	2025-10-30 18:09:30.850734	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
1364	2025-10-30 18:09:30.885494	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1365	2025-10-30 18:09:32.58612	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1366	2025-10-30 18:09:32.614497	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1367	2025-10-30 18:09:34.325955	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1368	2025-10-30 18:09:34.982263	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1369	2025-10-30 18:09:35.564842	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1370	2025-10-30 18:09:35.577893	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1371	2025-10-30 18:09:42.519536	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1372	2025-10-30 18:09:42.540064	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1373	2025-10-30 18:09:43.024441	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
1374	2025-10-30 18:09:43.053856	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1375	2025-10-30 18:09:44.801361	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1377	2025-10-30 18:09:44.917921	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1379	2025-10-30 18:09:48.308726	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1381	2025-10-30 18:09:48.937526	1	1	GET /api/product-warehouses	/api/product-warehouses	GET	127.0.0.1	200
1383	2025-10-30 18:09:49.590204	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1385	2025-10-30 18:09:50.118708	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1387	2025-10-30 18:09:50.966453	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1436	2025-10-31 11:51:49.549186	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
1441	2025-10-31 11:51:59.164328	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
1446	2025-10-31 11:53:35.70543	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1451	2025-10-31 11:53:40.942304	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1456	2025-10-31 11:53:49.515671	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1461	2025-10-31 11:54:25.206915	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1466	2025-10-31 11:54:27.999075	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1471	2025-10-31 11:55:10.938904	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
1658	2025-10-31 15:05:27.288981	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1663	2025-10-31 15:05:27.611011	\N	\N	GET /api/users	/api/users	GET	127.0.0.1	200
1847	2025-10-31 16:14:22.573036	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1854	2025-10-31 16:14:27.764993	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1859	2025-10-31 16:14:27.937973	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
635	2025-10-27 20:21:51.619426	1	1	GET /api/product-warehouses	/api/product-warehouses	GET	127.0.0.1	200
640	2025-10-27 20:22:04.155555	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
645	2025-10-27 20:22:12.984437	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
649	2025-10-27 20:22:25.297523	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
653	2025-10-27 20:22:25.591722	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
659	2025-10-27 20:22:32.62562	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
662	2025-10-27 20:22:36.694385	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
666	2025-10-27 20:22:36.851596	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
671	2025-10-27 20:22:49.507626	\N	\N	OPTIONS /api/logs	/api/logs	OPTIONS	127.0.0.1	200
674	2025-10-27 20:23:05.952536	1	1	GET /api/product-warehouses	/api/product-warehouses	GET	127.0.0.1	200
679	2025-10-27 20:23:18.494025	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
684	2025-10-27 20:23:29.256823	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
688	2025-10-27 20:23:34.350475	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
693	2025-10-27 20:23:45.065796	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
698	2025-10-27 20:24:08.432231	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
703	2025-10-27 20:24:08.611814	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
707	2025-10-27 20:24:19.398239	\N	\N	OPTIONS /api/dashboard/alerts	/api/dashboard/alerts	OPTIONS	127.0.0.1	200
712	2025-10-27 20:24:19.50979	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
717	2025-10-27 20:25:21.905615	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
722	2025-10-27 20:25:31.899499	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
727	2025-10-27 20:25:31.969491	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
733	2025-10-27 20:25:43.610018	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1308	2025-10-29 17:41:01.055847	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
1312	2025-10-29 17:41:14.112691	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1315	2025-10-29 17:41:49.281626	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1319	2025-10-29 17:41:51.440791	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
1376	2025-10-30 18:09:44.901808	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1378	2025-10-30 18:09:48.299322	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1380	2025-10-30 18:09:48.898503	\N	\N	OPTIONS /api/product-warehouses	/api/product-warehouses	OPTIONS	127.0.0.1	200
1382	2025-10-30 18:09:49.569068	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1384	2025-10-30 18:09:50.098296	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1386	2025-10-30 18:09:50.940785	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
1475	2025-10-31 11:56:59.435132	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1480	2025-10-31 12:00:47.52172	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1659	2025-10-31 15:05:27.298976	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
1862	2025-10-31 16:14:30.923161	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1864	2025-10-31 16:14:57.768288	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
1869	2025-10-31 16:14:58.0694	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
1873	2025-10-31 16:16:01.387221	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
1877	2025-10-31 16:16:01.511096	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
2029	2025-10-31 17:58:15.790207	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
2032	2025-10-31 17:58:17.394286	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
2036	2025-10-31 17:58:17.447645	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2039	2025-10-31 17:58:29.549737	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2042	2025-10-31 17:58:29.571577	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
2047	2025-10-31 17:58:29.638034	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
2051	2025-10-31 17:58:42.481332	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
2284	2025-10-31 19:04:00.03576	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
2285	2025-10-31 19:04:00.119097	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
2288	2025-10-31 19:04:00.176079	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2291	2025-10-31 19:05:04.91998	1	1	POST /api/boms	/api/boms	POST	127.0.0.1	400
2426	2025-11-05 04:55:36.02055	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2432	2025-11-05 04:55:36.268739	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
2440	2025-11-05 04:55:49.283732	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2446	2025-11-05 04:55:59.141608	\N	\N	OPTIONS /api/movements	/api/movements	OPTIONS	127.0.0.1	200
2452	2025-11-05 04:56:51.634311	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2458	2025-11-05 04:57:22.459927	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
2464	2025-11-05 04:57:38.204059	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
2470	2025-11-05 04:57:53.17717	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2476	2025-11-05 04:57:55.578052	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2481	2025-11-05 04:58:03.244626	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
2489	2025-11-05 04:58:18.369273	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2494	2025-11-05 04:58:30.992014	\N	\N	OPTIONS /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	OPTIONS	127.0.0.1	200
2500	2025-11-05 04:58:31.295775	1	1	GET /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	GET	127.0.0.1	200
2508	2025-11-05 04:58:50.114717	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
2624	2025-11-05 05:44:26.30057	\N	\N	OPTIONS /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	OPTIONS	127.0.0.1	200
2629	2025-11-05 05:44:36.166541	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2634	2025-11-05 05:44:51.709988	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
2639	2025-11-05 05:46:52.309631	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2644	2025-11-05 05:46:52.379215	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
636	2025-10-27 20:22:00.48702	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
641	2025-10-27 20:22:04.184571	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
646	2025-10-27 20:22:16.253558	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
650	2025-10-27 20:22:25.297523	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
654	2025-10-27 20:22:32.495361	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
667	2025-10-27 20:22:36.861269	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
672	2025-10-27 20:22:49.514719	\N	\N	OPTIONS /api/logs	/api/logs	OPTIONS	127.0.0.1	200
675	2025-10-27 20:23:09.881252	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
680	2025-10-27 20:23:18.547018	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
686	2025-10-27 20:23:29.280561	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
690	2025-10-27 20:23:34.389039	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
695	2025-10-27 20:23:45.142954	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
700	2025-10-27 20:24:08.512664	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
704	2025-10-27 20:24:19.37905	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
709	2025-10-27 20:24:19.434987	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
713	2025-10-27 20:24:20.49179	\N	\N	OPTIONS /api/user-org	/api/user-org	OPTIONS	127.0.0.1	404
718	2025-10-27 20:25:21.910569	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
723	2025-10-27 20:25:31.901494	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
728	2025-10-27 20:25:43.241322	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
732	2025-10-27 20:25:43.601511	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1309	2025-10-29 17:41:01.097123	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1313	2025-10-29 17:41:14.152486	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1316	2025-10-29 17:41:49.305433	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1320	2025-10-29 17:41:51.477898	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1323	2025-10-29 17:41:53.94035	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1476	2025-10-31 11:56:59.624374	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1481	2025-10-31 12:00:47.525218	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1664	2025-10-31 15:13:02.305525	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
1666	2025-10-31 15:13:05.472357	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
1669	2025-10-31 15:13:05.70362	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
1673	2025-10-31 15:13:05.890845	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1679	2025-10-31 15:13:08.981236	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1684	2025-10-31 15:13:19.508807	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1689	2025-10-31 15:13:38.002625	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1694	2025-10-31 15:13:40.425366	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1699	2025-10-31 15:13:40.505561	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1704	2025-10-31 15:13:41.979861	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1709	2025-10-31 15:13:46.296342	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1715	2025-10-31 15:13:46.730209	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1719	2025-10-31 15:13:46.800193	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1724	2025-10-31 15:13:56.592283	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1729	2025-10-31 15:15:46.353449	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1734	2025-10-31 15:15:54.492988	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1739	2025-10-31 15:15:54.629375	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1866	2025-10-31 16:14:57.949776	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
1870	2025-10-31 16:16:01.365202	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1874	2025-10-31 16:16:01.414915	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2052	2025-10-31 18:03:52.11303	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
2053	2025-10-31 18:03:54.205284	1	1	PUT /api/work-orders/2/start	/api/work-orders/2/start	PUT	127.0.0.1	200
2286	2025-10-31 19:04:00.137817	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2289	2025-10-31 19:04:00.183009	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
2427	2025-11-05 04:55:36.066736	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
2433	2025-11-05 04:55:47.223526	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
2437	2025-11-05 04:55:49.256556	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
2442	2025-11-05 04:55:49.414473	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
2448	2025-11-05 04:56:29.157623	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2454	2025-11-05 04:57:10.929283	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
2460	2025-11-05 04:57:25.11243	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
2466	2025-11-05 04:57:46.491918	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2472	2025-11-05 04:57:53.308999	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
2478	2025-11-05 04:58:03.169087	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2484	2025-11-05 04:58:18.327421	\N	\N	OPTIONS /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	OPTIONS	127.0.0.1	200
2490	2025-11-05 04:58:18.408744	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
2495	2025-11-05 04:58:31.002172	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
2501	2025-11-05 04:58:31.342096	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
2506	2025-11-05 04:58:50.087512	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2628	2025-11-05 05:44:26.469175	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2633	2025-11-05 05:44:51.70597	\N	\N	OPTIONS /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	OPTIONS	127.0.0.1	200
2637	2025-11-05 05:44:51.743236	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
2642	2025-11-05 05:46:52.364206	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
2647	2025-11-05 05:46:52.631381	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
637	2025-10-27 20:22:00.509446	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
642	2025-10-27 20:22:08.793025	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
647	2025-10-27 20:22:16.256139	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
652	2025-10-27 20:22:25.52703	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
657	2025-10-27 20:22:32.600063	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
664	2025-10-27 20:22:36.729162	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
669	2025-10-27 20:22:43.125832	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
677	2025-10-27 20:23:15.331424	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
682	2025-10-27 20:23:29.123664	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
691	2025-10-27 20:23:34.573572	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
696	2025-10-27 20:23:45.169376	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
702	2025-10-27 20:24:08.569853	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
706	2025-10-27 20:24:19.384914	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
711	2025-10-27 20:24:19.482822	1	1	GET /api/dashboard/alerts	/api/dashboard/alerts	GET	127.0.0.1	200
716	2025-10-27 20:24:38.859806	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
721	2025-10-27 20:25:22.032647	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
726	2025-10-27 20:25:31.952844	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
731	2025-10-27 20:25:43.582265	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
734	2025-10-27 20:32:15.258088	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
735	2025-10-27 20:32:15.263573	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
736	2025-10-27 20:32:15.46875	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
737	2025-10-27 20:32:15.487912	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
738	2025-10-27 20:32:15.640289	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
739	2025-10-27 20:32:36.03458	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
740	2025-10-27 20:32:36.037578	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
741	2025-10-27 20:32:36.228777	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
742	2025-10-27 20:32:36.23079	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
743	2025-10-27 20:32:36.339366	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
744	2025-10-27 20:33:35.710881	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
745	2025-10-27 20:33:35.712015	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
746	2025-10-27 20:33:35.725612	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
747	2025-10-27 20:33:35.750484	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
748	2025-10-27 20:33:35.763593	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
749	2025-10-27 20:33:44.240986	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
750	2025-10-27 20:33:44.245064	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
751	2025-10-27 20:33:44.514461	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
752	2025-10-27 20:33:44.530454	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
753	2025-10-27 20:33:44.929376	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
754	2025-10-27 20:33:52.690325	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
755	2025-10-27 20:33:52.693458	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
756	2025-10-27 20:33:52.747385	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
757	2025-10-27 20:33:52.761969	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
758	2025-10-27 20:33:52.796791	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
759	2025-10-27 20:34:01.584513	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
760	2025-10-27 20:34:01.590206	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
761	2025-10-27 20:34:01.747737	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
762	2025-10-27 20:34:01.776078	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
763	2025-10-27 20:34:01.822455	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
764	2025-10-27 20:37:40.354329	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
765	2025-10-27 20:37:40.354329	\N	\N	OPTIONS /api/dashboard/alerts	/api/dashboard/alerts	OPTIONS	127.0.0.1	200
766	2025-10-27 20:37:40.367835	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
767	2025-10-27 20:37:40.445746	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
768	2025-10-27 20:37:40.530407	1	1	GET /api/dashboard/alerts	/api/dashboard/alerts	GET	127.0.0.1	200
769	2025-10-27 20:37:40.567803	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
770	2025-10-27 20:45:16.38612	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
771	2025-10-27 20:45:16.390767	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
772	2025-10-27 20:45:16.396401	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
773	2025-10-27 20:45:16.397505	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
774	2025-10-27 20:45:16.447107	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
775	2025-10-27 20:45:16.466237	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
776	2025-10-27 20:45:16.483802	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
777	2025-10-27 20:45:16.496881	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
778	2025-10-27 20:45:16.553683	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
779	2025-10-27 20:46:43.470367	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
780	2025-10-27 20:46:45.531683	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
781	2025-10-27 20:46:47.588185	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
782	2025-10-27 20:47:50.442839	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
783	2025-10-27 20:47:50.452851	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
784	2025-10-27 20:47:50.453857	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
785	2025-10-27 20:47:50.459593	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
786	2025-10-27 20:47:50.49011	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
787	2025-10-27 20:47:50.523942	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1477	2025-10-31 12:00:47.441808	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1482	2025-10-31 12:00:47.551712	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1487	2025-10-31 12:05:16.60436	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1490	2025-10-31 12:05:16.772252	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1665	2025-10-31 15:13:03.172117	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
1667	2025-10-31 15:13:05.509553	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1668	2025-10-31 15:13:05.658621	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1674	2025-10-31 15:13:05.903397	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1678	2025-10-31 15:13:08.961017	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1683	2025-10-31 15:13:19.480111	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
1688	2025-10-31 15:13:38.000091	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
1692	2025-10-31 15:13:38.079078	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
1697	2025-10-31 15:13:40.45415	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
1702	2025-10-31 15:13:41.644248	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1706	2025-10-31 15:13:42.014315	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1713	2025-10-31 15:13:46.421665	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
1718	2025-10-31 15:13:46.769643	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1723	2025-10-31 15:13:56.565312	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1727	2025-10-31 15:15:46.3148	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1731	2025-10-31 15:15:46.447702	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1735	2025-10-31 15:15:54.525718	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1740	2025-10-31 15:15:54.632377	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1867	2025-10-31 16:14:57.952809	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1871	2025-10-31 16:16:01.367738	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1875	2025-10-31 16:16:01.436905	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2054	2025-10-31 18:06:11.176254	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2055	2025-10-31 18:06:11.299615	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2059	2025-10-31 18:06:11.372018	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
2063	2025-10-31 18:06:19.68654	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2066	2025-10-31 18:07:17.499936	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2069	2025-10-31 18:07:17.551225	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2287	2025-10-31 19:04:00.148382	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
2290	2025-10-31 19:05:04.907033	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
2429	2025-11-05 04:55:36.249546	\N	\N	GET /api/menu	/api/menu	GET	127.0.0.1	401
2435	2025-11-05 04:55:49.179955	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2441	2025-11-05 04:55:49.314027	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
2447	2025-11-05 04:55:59.284012	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
2453	2025-11-05 04:56:51.670556	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2459	2025-11-05 04:57:25.072536	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
2465	2025-11-05 04:57:46.46619	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2469	2025-11-05 04:57:53.166616	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2475	2025-11-05 04:57:55.574742	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2480	2025-11-05 04:58:03.212541	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2486	2025-11-05 04:58:18.340556	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
2491	2025-11-05 04:58:30.943655	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2497	2025-11-05 04:58:31.160256	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2503	2025-11-05 04:58:49.980879	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
2649	2025-11-05 06:38:36.422857	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
2651	2025-11-05 06:39:26.510819	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
2656	2025-11-05 06:39:26.67104	\N	\N	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	401
2661	2025-11-05 06:39:42.920405	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2665	2025-11-05 06:39:42.999009	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
2670	2025-11-05 06:39:47.88847	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2675	2025-11-05 06:39:53.76819	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2680	2025-11-05 06:40:13.37375	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2685	2025-11-05 06:40:13.485339	1	1	GET /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	GET	127.0.0.1	200
2690	2025-11-05 06:43:08.354477	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2695	2025-11-05 06:43:21.184988	\N	\N	OPTIONS /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	OPTIONS	127.0.0.1	200
2700	2025-11-05 06:43:21.254022	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
2706	2025-11-05 06:43:32.142335	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
2795	2025-11-05 15:40:58.139701	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2925	2025-11-05 16:17:39.110096	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
2979	2025-11-05 17:57:04.447186	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
2982	2025-11-05 17:57:04.593153	\N	\N	GET /api/menu	/api/menu	GET	127.0.0.1	401
2985	2025-11-05 17:57:40.897022	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
2988	2025-11-05 17:57:42.867551	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
2990	2025-11-05 17:57:43.01733	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2995	2025-11-05 17:57:43.417485	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
3022	2025-11-05 18:26:09.798765	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3027	2025-11-05 18:27:36.188862	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3032	2025-11-05 18:27:47.086601	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
788	2025-10-27 20:47:50.538176	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1478	2025-10-31 12:00:47.451934	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1483	2025-10-31 12:02:43.670121	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1488	2025-10-31 12:05:16.624653	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1493	2025-10-31 12:05:20.68065	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
1670	2025-10-31 15:13:05.738387	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1675	2025-10-31 15:13:05.921864	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1680	2025-10-31 15:13:19.35157	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1686	2025-10-31 15:13:19.554397	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1693	2025-10-31 15:13:38.087115	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
1698	2025-10-31 15:13:40.485153	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1701	2025-10-31 15:13:41.630426	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
1707	2025-10-31 15:13:42.022317	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1712	2025-10-31 15:13:46.38482	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1717	2025-10-31 15:13:46.732454	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
1721	2025-10-31 15:13:56.527252	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1726	2025-10-31 15:15:46.272069	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1730	2025-10-31 15:15:46.429647	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1736	2025-10-31 15:15:54.540964	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1878	2025-10-31 16:21:08.848874	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1882	2025-10-31 16:21:11.776206	\N	\N	OPTIONS /api/work-orders/2/start	/api/work-orders/2/start	OPTIONS	127.0.0.1	200
2056	2025-10-31 18:06:11.301101	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
2058	2025-10-31 18:06:11.358281	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
2061	2025-10-31 18:06:19.668309	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
2064	2025-10-31 18:06:19.714195	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
2067	2025-10-31 18:07:17.501935	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2070	2025-10-31 18:10:25.575908	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
2073	2025-10-31 18:10:25.627309	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
2076	2025-10-31 18:11:08.907831	\N	\N	OPTIONS /api/movements	/api/movements	OPTIONS	127.0.0.1	200
2292	2025-10-31 19:08:31.958737	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
2293	2025-10-31 19:08:32.069044	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
2298	2025-10-31 19:08:32.123661	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2303	2025-10-31 19:08:44.578337	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
2310	2025-10-31 19:08:44.660276	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
2314	2025-10-31 19:09:52.210124	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
2320	2025-10-31 19:10:07.050398	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2325	2025-10-31 19:10:14.395497	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
2330	2025-10-31 19:10:15.572325	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2335	2025-10-31 19:10:16.901653	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
2340	2025-10-31 19:10:31.898122	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
2343	2025-10-31 19:10:31.928851	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
2348	2025-10-31 19:10:39.837029	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
2353	2025-10-31 19:10:39.907377	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
2431	2025-11-05 04:55:36.264171	\N	\N	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	401
2439	2025-11-05 04:55:49.282729	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2445	2025-11-05 04:55:54.757658	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
2451	2025-11-05 04:56:42.216095	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
2457	2025-11-05 04:57:18.835019	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
2463	2025-11-05 04:57:38.167933	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
2468	2025-11-05 04:57:53.150099	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
2474	2025-11-05 04:57:55.550118	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2482	2025-11-05 04:58:03.248336	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
2487	2025-11-05 04:58:18.357101	1	1	GET /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	GET	127.0.0.1	200
2492	2025-11-05 04:58:30.957901	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
2499	2025-11-05 04:58:31.282252	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
2505	2025-11-05 04:58:50.062118	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
2650	2025-11-05 06:39:18.686742	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
2652	2025-11-05 06:39:26.603819	\N	\N	GET /api/users	/api/users	GET	127.0.0.1	200
2657	2025-11-05 06:39:26.675277	\N	\N	GET /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	GET	127.0.0.1	401
2662	2025-11-05 06:39:42.923565	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
2668	2025-11-05 06:39:43.03654	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
2673	2025-11-05 06:39:47.955562	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2678	2025-11-05 06:39:53.802214	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2683	2025-11-05 06:40:13.389075	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
2688	2025-11-05 06:43:08.344947	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
2691	2025-11-05 06:43:08.468881	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2696	2025-11-05 06:43:21.190018	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
2701	2025-11-05 06:43:21.274977	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
2705	2025-11-05 06:43:32.123569	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2798	2025-11-05 15:40:58.524319	1	1	GET /api/suppliers	/api/suppliers	GET	127.0.0.1	200
2926	2025-11-05 16:23:00.604634	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
2927	2025-11-05 16:23:05.385443	1	1	REPORT_NL ok=True rows=1 err=	/api/reports/nl	POST	127.0.0.1	\N
2929	2025-11-05 16:23:09.459344	1	1	POST /api/reports/nl	/api/reports/nl	POST	127.0.0.1	200
789	2025-10-27 20:47:50.557012	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1479	2025-10-31 12:00:47.470031	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1484	2025-10-31 12:02:43.706118	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1489	2025-10-31 12:05:16.721936	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1494	2025-10-31 12:05:20.819088	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1671	2025-10-31 15:13:05.741408	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1676	2025-10-31 15:13:08.868348	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1681	2025-10-31 15:13:19.453615	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1685	2025-10-31 15:13:19.546397	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1690	2025-10-31 15:13:38.009629	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
1696	2025-10-31 15:13:40.453154	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1703	2025-10-31 15:13:41.669687	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
1708	2025-10-31 15:13:46.290338	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
1711	2025-10-31 15:13:46.371812	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
1716	2025-10-31 15:13:46.731202	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1722	2025-10-31 15:13:56.531768	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1728	2025-10-31 15:15:46.352462	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1733	2025-10-31 15:15:54.47115	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1737	2025-10-31 15:15:54.568957	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1879	2025-10-31 16:21:08.849864	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1883	2025-10-31 16:21:11.878419	1	1	PUT /api/work-orders/2/start	/api/work-orders/2/start	PUT	127.0.0.1	400
2057	2025-10-31 18:06:11.305122	\N	\N	OPTIONS /api/movements	/api/movements	OPTIONS	127.0.0.1	200
2060	2025-10-31 18:06:19.658571	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2062	2025-10-31 18:06:19.676519	\N	\N	OPTIONS /api/movements	/api/movements	OPTIONS	127.0.0.1	200
2065	2025-10-31 18:06:19.822493	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
2068	2025-10-31 18:07:17.527832	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2071	2025-10-31 18:10:25.57791	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2072	2025-10-31 18:10:25.61212	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2075	2025-10-31 18:10:25.814171	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
2294	2025-10-31 19:08:32.085972	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2300	2025-10-31 19:08:32.189501	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2305	2025-10-31 19:08:44.584263	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2309	2025-10-31 19:08:44.653135	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2317	2025-10-31 19:10:07.020136	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
2322	2025-10-31 19:10:07.113491	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
2327	2025-10-31 19:10:14.423853	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2332	2025-10-31 19:10:15.593518	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2337	2025-10-31 19:10:16.922487	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2342	2025-10-31 19:10:31.904124	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
2347	2025-10-31 19:10:39.810967	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2352	2025-10-31 19:10:39.885146	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
2449	2025-11-05 04:56:29.182573	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2455	2025-11-05 04:57:10.960581	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
2461	2025-11-05 04:57:35.199965	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2471	2025-11-05 04:57:53.292315	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2477	2025-11-05 04:58:03.16483	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
2483	2025-11-05 04:58:18.32502	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2488	2025-11-05 04:58:18.363155	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
2493	2025-11-05 04:58:30.973964	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2498	2025-11-05 04:58:31.276569	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2504	2025-11-05 04:58:49.983879	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2653	2025-11-05 06:39:26.64119	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
2658	2025-11-05 06:39:26.681796	\N	\N	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	401
2663	2025-11-05 06:39:42.927568	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
2667	2025-11-05 06:39:43.01433	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
2672	2025-11-05 06:39:47.928589	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2679	2025-11-05 06:39:53.8268	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
2684	2025-11-05 06:40:13.477391	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2689	2025-11-05 06:43:08.347951	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
2694	2025-11-05 06:43:21.181451	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2699	2025-11-05 06:43:21.251535	1	1	GET /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	GET	127.0.0.1	200
2704	2025-11-05 06:43:32.098296	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
2799	2025-11-05 15:55:52.419844	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2803	2025-11-05 15:55:59.303582	\N	\N	OPTIONS /api/movements	/api/movements	OPTIONS	127.0.0.1	200
2807	2025-11-05 15:56:04.017787	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
2811	2025-11-05 15:56:08.031647	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
2815	2025-11-05 15:56:13.635927	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
2819	2025-11-05 15:56:40.318183	\N	\N	OPTIONS /api/suppliers	/api/suppliers	OPTIONS	127.0.0.1	200
2821	2025-11-05 15:56:40.378034	1	1	GET /api/supplier-items	/api/supplier-items	GET	127.0.0.1	200
2825	2025-11-05 15:57:19.133872	\N	\N	OPTIONS /api/supplier-items	/api/supplier-items	OPTIONS	127.0.0.1	200
2830	2025-11-05 15:57:19.269894	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
790	2025-10-27 20:47:50.557012	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
791	2025-10-27 20:52:02.729787	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
792	2025-10-27 20:52:02.848997	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
793	2025-10-27 20:52:02.925761	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
794	2025-10-27 20:52:02.925761	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
795	2025-10-27 20:52:02.963578	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
796	2025-10-27 20:52:03.015069	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
797	2025-10-27 20:52:03.016858	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
798	2025-10-27 20:52:03.074217	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
799	2025-10-27 20:52:03.087169	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
800	2025-10-27 20:54:20.443545	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
801	2025-10-27 20:54:20.465955	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
802	2025-10-27 20:54:20.513665	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
803	2025-10-27 20:54:20.831107	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
804	2025-10-27 20:54:20.841422	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
805	2025-10-27 20:54:20.846376	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
806	2025-10-27 20:54:20.870419	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
807	2025-10-27 20:54:20.964165	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
808	2025-10-27 20:54:21.071037	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
809	2025-10-27 20:55:07.901398	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
810	2025-10-27 20:55:07.929568	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
811	2025-10-27 20:55:10.482175	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
812	2025-10-27 20:55:10.513885	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
813	2025-10-27 20:55:22.924087	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
814	2025-10-27 20:55:22.952085	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
815	2025-10-27 20:55:27.609934	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
816	2025-10-27 20:55:27.632924	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
817	2025-10-27 20:55:30.711639	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
818	2025-10-27 20:55:30.738404	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
819	2025-10-27 20:55:32.934889	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
820	2025-10-27 20:55:32.936404	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
821	2025-10-27 20:55:32.936404	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
822	2025-10-27 20:55:33.036067	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
823	2025-10-27 20:55:33.049084	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
824	2025-10-27 20:55:33.057068	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
825	2025-10-27 20:57:32.939505	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
826	2025-10-27 20:57:33.100423	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
827	2025-10-27 20:57:36.259384	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
828	2025-10-27 20:57:36.264336	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
829	2025-10-27 20:57:36.30414	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
830	2025-10-27 20:57:36.332449	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
831	2025-10-27 20:57:36.388707	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
832	2025-10-27 20:59:35.438079	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
833	2025-10-27 20:59:35.455194	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
834	2025-10-27 20:59:35.481791	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
835	2025-10-27 20:59:35.528901	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
836	2025-10-27 20:59:35.566183	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
837	2025-10-27 20:59:35.570378	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
838	2025-10-27 20:59:35.639712	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
839	2025-10-27 20:59:35.665506	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
840	2025-10-27 20:59:35.700074	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
841	2025-10-27 21:01:21.921405	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
842	2025-10-27 21:01:21.928165	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
843	2025-10-27 21:01:21.93598	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
844	2025-10-27 21:01:21.943658	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
845	2025-10-27 21:01:21.968891	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
846	2025-10-27 21:01:21.985821	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
847	2025-10-27 21:01:22.016478	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
848	2025-10-27 21:01:22.022502	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
849	2025-10-27 21:01:22.028835	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
850	2025-10-27 21:02:59.33405	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
851	2025-10-27 21:02:59.379992	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
852	2025-10-27 21:02:59.447198	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
853	2025-10-27 21:02:59.470924	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
854	2025-10-27 21:02:59.479852	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
855	2025-10-27 21:02:59.495573	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
856	2025-10-27 21:02:59.507739	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
857	2025-10-27 21:02:59.545925	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
858	2025-10-27 21:02:59.550989	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
859	2025-10-27 21:03:17.994565	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
860	2025-10-27 21:03:17.999451	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
861	2025-10-27 21:03:18.007939	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
866	2025-10-27 21:03:18.088932	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
1485	2025-10-31 12:03:54.505578	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1491	2025-10-31 12:05:16.78147	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1495	2025-10-31 12:06:05.323422	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1504	2025-10-31 12:07:19.629656	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1509	2025-10-31 12:08:02.466089	1	1	GET /api/suppliers	/api/suppliers	GET	127.0.0.1	200
1672	2025-10-31 15:13:05.742403	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1677	2025-10-31 15:13:08.871406	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1682	2025-10-31 15:13:19.457636	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1687	2025-10-31 15:13:19.586121	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
1691	2025-10-31 15:13:38.050263	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1695	2025-10-31 15:13:40.441135	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1700	2025-10-31 15:13:40.538662	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
1705	2025-10-31 15:13:41.985873	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1710	2025-10-31 15:13:46.302359	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
1714	2025-10-31 15:13:46.715204	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1720	2025-10-31 15:13:46.825922	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
1725	2025-10-31 15:15:46.242599	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1732	2025-10-31 15:15:46.464821	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1738	2025-10-31 15:15:54.611225	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1880	2025-10-31 16:21:09.0569	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1884	2025-10-31 16:21:56.908741	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
2074	2025-10-31 18:10:25.792848	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
2077	2025-10-31 18:11:08.938574	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
2078	2025-10-31 18:13:08.478183	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2079	2025-10-31 18:13:08.520773	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2082	2025-10-31 18:13:08.627241	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
2085	2025-10-31 18:13:24.070216	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
2088	2025-10-31 18:14:03.24332	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2091	2025-10-31 18:14:31.752145	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2094	2025-10-31 18:14:45.32721	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
2097	2025-10-31 18:15:17.531981	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2100	2025-10-31 18:15:17.564455	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2295	2025-10-31 19:08:32.095978	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2299	2025-10-31 19:08:32.141207	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
2304	2025-10-31 19:08:44.584263	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
2311	2025-10-31 19:08:44.674434	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
2315	2025-10-31 19:10:07.001482	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2319	2025-10-31 19:10:07.0474	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2324	2025-10-31 19:10:14.39318	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2329	2025-10-31 19:10:15.56928	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2333	2025-10-31 19:10:16.89065	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2338	2025-10-31 19:10:16.927744	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
2345	2025-10-31 19:10:31.95591	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
2351	2025-10-31 19:10:39.868844	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2509	2025-11-05 05:09:51.753355	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2514	2025-11-05 05:09:52.311159	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
2654	2025-11-05 06:39:26.642862	\N	\N	OPTIONS /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	OPTIONS	127.0.0.1	200
2659	2025-11-05 06:39:41.062439	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
2664	2025-11-05 06:39:42.932569	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
2669	2025-11-05 06:39:43.070843	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2674	2025-11-05 06:39:53.766973	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
2677	2025-11-05 06:39:53.796042	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
2682	2025-11-05 06:40:13.387078	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
2687	2025-11-05 06:40:13.52559	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
2692	2025-11-05 06:43:08.476007	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
2697	2025-11-05 06:43:21.191529	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
2702	2025-11-05 06:43:32.093284	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
2707	2025-11-05 06:43:32.156813	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
2800	2025-11-05 15:55:52.6122	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2804	2025-11-05 15:55:59.359856	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
2808	2025-11-05 15:56:04.061212	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
2812	2025-11-05 15:56:10.366876	\N	\N	OPTIONS /api/movements	/api/movements	OPTIONS	127.0.0.1	200
2816	2025-11-05 15:56:20.800476	\N	\N	OPTIONS /api/suppliers	/api/suppliers	OPTIONS	127.0.0.1	200
2820	2025-11-05 15:56:40.321709	\N	\N	OPTIONS /api/supplier-items	/api/supplier-items	OPTIONS	127.0.0.1	200
2824	2025-11-05 15:57:19.045701	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2828	2025-11-05 15:57:19.214367	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
2831	2025-11-05 15:57:19.282488	1	1	GET /api/suppliers	/api/suppliers	GET	127.0.0.1	200
2928	2025-11-05 16:23:05.391681	1	1	POST /api/reports/nl	/api/reports/nl	POST	127.0.0.1	200
2980	2025-11-05 17:57:04.454336	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2983	2025-11-05 17:57:04.598667	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
862	2025-10-27 21:03:18.014558	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
865	2025-10-27 21:03:18.076089	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1486	2025-10-31 12:03:54.65747	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1492	2025-10-31 12:05:16.791413	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1496	2025-10-31 12:06:05.405134	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1500	2025-10-31 12:07:19.579999	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1503	2025-10-31 12:07:19.612103	1	1	GET /api/roles	/api/roles	GET	127.0.0.1	200
1508	2025-10-31 12:08:02.382781	\N	\N	OPTIONS /api/suppliers	/api/suppliers	OPTIONS	127.0.0.1	200
1741	2025-10-31 15:16:05.192366	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1748	2025-10-31 15:16:05.296047	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1753	2025-10-31 15:16:50.340846	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1758	2025-10-31 15:17:10.444239	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1761	2025-10-31 15:17:10.551964	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1881	2025-10-31 16:21:09.079211	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1885	2025-10-31 16:21:58.990402	1	1	PUT /api/work-orders/2/start	/api/work-orders/2/start	PUT	127.0.0.1	400
2080	2025-10-31 18:13:08.586012	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
2083	2025-10-31 18:13:08.654779	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
2086	2025-10-31 18:13:33.015798	\N	\N	OPTIONS /api/movements	/api/movements	OPTIONS	127.0.0.1	200
2089	2025-10-31 18:14:03.282351	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2092	2025-10-31 18:14:42.961195	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
2095	2025-10-31 18:14:45.368294	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
2098	2025-10-31 18:15:17.533938	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2101	2025-10-31 18:15:32.161093	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
2104	2025-10-31 18:15:32.210758	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
2296	2025-10-31 19:08:32.103113	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
2301	2025-10-31 19:08:32.192497	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
2306	2025-10-31 19:08:44.590262	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
2307	2025-10-31 19:08:44.635977	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
2312	2025-10-31 19:09:52.096496	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
2316	2025-10-31 19:10:07.006298	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2321	2025-10-31 19:10:07.085826	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
2328	2025-10-31 19:10:14.445986	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
2334	2025-10-31 19:10:16.895652	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2339	2025-10-31 19:10:16.946972	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
2344	2025-10-31 19:10:31.93786	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2349	2025-10-31 19:10:39.839031	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
2354	2025-10-31 19:11:01.354193	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2510	2025-11-05 05:09:52.048474	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
2515	2025-11-05 05:09:52.325373	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
2655	2025-11-05 06:39:26.645897	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2660	2025-11-05 06:39:41.239941	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
2666	2025-11-05 06:39:43.002525	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2671	2025-11-05 06:39:47.917307	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2676	2025-11-05 06:39:53.771251	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
2681	2025-11-05 06:40:13.378487	\N	\N	OPTIONS /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	OPTIONS	127.0.0.1	200
2686	2025-11-05 06:40:13.497038	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
2693	2025-11-05 06:43:08.491563	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
2698	2025-11-05 06:43:21.222418	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2703	2025-11-05 06:43:32.095295	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2801	2025-11-05 15:55:56.363158	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
2805	2025-11-05 15:56:01.371955	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2809	2025-11-05 15:56:06.228401	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
2813	2025-11-05 15:56:10.401119	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
2817	2025-11-05 15:56:20.818107	1	1	GET /api/suppliers	/api/suppliers	GET	127.0.0.1	200
2823	2025-11-05 15:56:40.385609	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2827	2025-11-05 15:57:19.199456	\N	\N	OPTIONS /api/suppliers	/api/suppliers	OPTIONS	127.0.0.1	200
2832	2025-11-05 15:57:19.285492	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2930	2025-11-05 16:25:51.908346	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
2931	2025-11-05 16:25:56.138057	1	1	REPORT_NL ok=True rows=1 err=	/api/reports/nl	POST	127.0.0.1	\N
2933	2025-11-05 16:26:00.97913	1	1	POST /api/reports/nl	/api/reports/nl	POST	127.0.0.1	200
2981	2025-11-05 17:57:04.475494	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2984	2025-11-05 17:57:04.603761	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
2987	2025-11-05 17:57:42.867551	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2991	2025-11-05 17:57:43.024783	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
2996	2025-11-05 17:57:50.290445	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
3023	2025-11-05 18:26:09.996541	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3028	2025-11-05 18:27:36.191397	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
3033	2025-11-05 18:27:47.089139	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
3038	2025-11-05 18:28:08.314951	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
3051	2025-11-05 19:28:46.917002	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3056	2025-11-05 19:28:47.293594	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3062	2025-11-05 19:29:01.982699	1	1	POST /api/reports/nl	/api/reports/nl	POST	127.0.0.1	200
863	2025-10-27 21:03:18.061321	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1497	2025-10-31 12:06:05.423227	\N	\N	OPTIONS /api/user-org	/api/user-org	OPTIONS	127.0.0.1	404
1501	2025-10-31 12:07:19.581694	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1507	2025-10-31 12:07:20.994025	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1512	2025-10-31 12:09:22.727102	\N	\N	OPTIONS /api/product-warehouses	/api/product-warehouses	OPTIONS	127.0.0.1	200
1517	2025-10-31 12:09:32.112825	1	1	GET /api/product-warehouses	/api/product-warehouses	GET	127.0.0.1	200
1522	2025-10-31 12:10:53.422121	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1742	2025-10-31 15:16:05.195368	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1747	2025-10-31 15:16:05.282196	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1754	2025-10-31 15:16:50.358844	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
1759	2025-10-31 15:17:10.450767	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
1760	2025-10-31 15:17:10.537543	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
1886	2025-10-31 16:24:39.682988	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1887	2025-10-31 16:24:39.750452	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1892	2025-10-31 16:24:39.843985	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1895	2025-10-31 16:26:00.148901	1	1	PUT /api/work-orders/2/start	/api/work-orders/2/start	PUT	127.0.0.1	200
2081	2025-10-31 18:13:08.587014	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
2084	2025-10-31 18:13:24.050829	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
2087	2025-10-31 18:13:33.039256	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
2090	2025-10-31 18:14:31.733051	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2093	2025-10-31 18:14:43.014211	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
2096	2025-10-31 18:14:49.227788	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
2099	2025-10-31 18:15:17.551942	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2102	2025-10-31 18:15:32.162604	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2103	2025-10-31 18:15:32.193307	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2106	2025-10-31 18:15:32.292125	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
2297	2025-10-31 19:08:32.109492	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
2302	2025-10-31 19:08:44.575842	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2308	2025-10-31 19:08:44.646718	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2313	2025-10-31 19:09:52.145099	1	1	POST /api/boms	/api/boms	POST	127.0.0.1	201
2318	2025-10-31 19:10:07.023133	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
2323	2025-10-31 19:10:14.390281	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
2326	2025-10-31 19:10:14.417452	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
2331	2025-10-31 19:10:15.5915	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2336	2025-10-31 19:10:16.905655	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
2341	2025-10-31 19:10:31.900117	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2346	2025-10-31 19:10:39.804569	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2350	2025-10-31 19:10:39.86239	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2355	2025-10-31 19:11:01.372332	1	1	POST /api/work-orders	/api/work-orders	POST	127.0.0.1	400
2511	2025-11-05 05:09:52.10755	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
2516	2025-11-05 05:09:52.402261	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2708	2025-11-05 06:48:01.75605	\N	\N	OPTIONS /api/supplier-items	/api/supplier-items	OPTIONS	127.0.0.1	200
2711	2025-11-05 06:48:01.940562	1	1	GET /api/suppliers	/api/suppliers	GET	127.0.0.1	200
2802	2025-11-05 15:55:56.588387	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
2806	2025-11-05 15:56:01.401946	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2810	2025-11-05 15:56:07.981769	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
2814	2025-11-05 15:56:11.366526	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
2818	2025-11-05 15:56:40.316225	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2822	2025-11-05 15:56:40.380567	1	1	GET /api/suppliers	/api/suppliers	GET	127.0.0.1	200
2826	2025-11-05 15:57:19.180839	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2829	2025-11-05 15:57:19.250898	1	1	GET /api/supplier-items	/api/supplier-items	GET	127.0.0.1	200
2833	2025-11-05 15:57:19.334831	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
2932	2025-11-05 16:25:57.454702	1	1	POST /api/reports/nl	/api/reports/nl	POST	127.0.0.1	200
2986	2025-11-05 17:57:41.189085	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
2989	2025-11-05 17:57:43.014838	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2994	2025-11-05 17:57:43.405179	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
3024	2025-11-05 18:26:26.832712	\N	\N	OPTIONS /api/reports/nl	/api/reports/nl	OPTIONS	127.0.0.1	200
3029	2025-11-05 18:27:36.354499	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3034	2025-11-05 18:27:47.160157	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3039	2025-11-05 18:28:08.332666	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3052	2025-11-05 19:28:46.927376	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
3058	2025-11-05 19:28:47.294607	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
3063	2025-11-05 19:30:01.391341	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3095	2025-11-05 19:47:54.39111	\N	\N	OPTIONS /api/suppliers	/api/suppliers	OPTIONS	127.0.0.1	200
3100	2025-11-05 19:50:17.03687	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
3125	2025-11-07 10:17:25.718127	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
3128	2025-11-07 10:17:35.39372	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
3131	2025-11-07 10:17:37.32537	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
3133	2025-11-07 10:17:37.446704	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
3135	2025-11-07 10:17:37.464057	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
3137	2025-11-07 10:17:37.772842	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3140	2025-11-07 10:17:41.897138	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
864	2025-10-27 21:03:18.064003	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
867	2025-10-27 21:03:18.120638	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
868	2025-10-27 21:12:55.117703	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
869	2025-10-27 21:12:55.144011	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
870	2025-10-27 21:12:55.150543	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
871	2025-10-27 21:12:55.15677	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
872	2025-10-27 21:12:55.328668	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
873	2025-10-27 21:12:55.334493	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
874	2025-10-27 21:12:55.340585	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
875	2025-10-27 21:12:55.37454	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
876	2025-10-27 21:12:55.3921	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
877	2025-10-27 21:15:16.02999	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
878	2025-10-27 21:15:16.033915	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
879	2025-10-27 21:15:16.038223	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
880	2025-10-27 21:15:16.042845	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
881	2025-10-27 21:15:16.086062	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
882	2025-10-27 21:15:16.09051	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
883	2025-10-27 21:15:16.113253	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
884	2025-10-27 21:15:16.125422	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
885	2025-10-27 21:15:16.129687	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
886	2025-10-27 21:15:58.984106	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
887	2025-10-27 21:15:58.985166	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
888	2025-10-27 21:15:58.98768	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
889	2025-10-27 21:15:58.991795	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
890	2025-10-27 21:15:59.048669	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
891	2025-10-27 21:15:59.055198	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
892	2025-10-27 21:15:59.061651	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
893	2025-10-27 21:15:59.063688	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
894	2025-10-27 21:15:59.083255	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
895	2025-10-27 21:17:00.100961	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
896	2025-10-27 21:17:00.115389	\N	\N	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	401
897	2025-10-27 21:17:19.697459	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
898	2025-10-27 21:17:19.94215	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
899	2025-10-27 21:17:21.509021	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
900	2025-10-27 21:17:21.511427	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
901	2025-10-27 21:17:21.513637	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
902	2025-10-27 21:17:21.519966	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
903	2025-10-27 21:17:21.557185	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
904	2025-10-27 21:17:21.581576	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
905	2025-10-27 21:17:21.600667	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
906	2025-10-27 21:17:21.600667	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
907	2025-10-27 21:17:21.606098	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
908	2025-10-27 21:17:29.397817	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
909	2025-10-27 21:17:29.411528	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
910	2025-10-27 21:17:35.833229	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
911	2025-10-27 21:17:35.848471	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
912	2025-10-27 21:18:04.624277	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
913	2025-10-27 21:18:04.631534	\N	\N	OPTIONS /api/supplier-items	/api/supplier-items	OPTIONS	127.0.0.1	200
914	2025-10-27 21:18:04.637248	\N	\N	OPTIONS /api/suppliers	/api/suppliers	OPTIONS	127.0.0.1	200
915	2025-10-27 21:18:04.663868	1	1	GET /api/supplier-items	/api/supplier-items	GET	127.0.0.1	200
916	2025-10-27 21:18:04.667312	1	1	GET /api/suppliers	/api/suppliers	GET	127.0.0.1	200
917	2025-10-27 21:18:04.774973	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
918	2025-10-27 21:18:39.021791	\N	\N	OPTIONS /api/suppliers	/api/suppliers	OPTIONS	127.0.0.1	200
919	2025-10-27 21:18:39.085534	1	1	GET /api/suppliers	/api/suppliers	GET	127.0.0.1	200
920	2025-10-27 21:24:27.746602	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
921	2025-10-27 21:24:27.746602	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
922	2025-10-27 21:24:27.748688	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
923	2025-10-27 21:24:27.809069	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
924	2025-10-27 21:24:27.825455	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
925	2025-10-27 21:24:27.922632	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
926	2025-10-27 21:24:35.808804	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
927	2025-10-27 21:24:35.831122	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
928	2025-10-27 21:24:41.777928	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
929	2025-10-27 21:24:41.785811	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
930	2025-10-27 21:24:41.785811	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
931	2025-10-27 21:24:41.843931	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
932	2025-10-27 21:24:41.848368	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
933	2025-10-27 21:24:41.858503	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
934	2025-10-27 21:24:46.182978	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
935	2025-10-27 21:24:46.227771	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
936	2025-10-27 21:24:55.144123	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
937	2025-10-27 21:24:55.144123	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
939	2025-10-27 21:24:55.197805	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1498	2025-10-31 12:07:00.274239	\N	\N	OPTIONS /api/roles	/api/roles	OPTIONS	127.0.0.1	200
1502	2025-10-31 12:07:19.592483	\N	\N	OPTIONS /api/roles	/api/roles	OPTIONS	127.0.0.1	200
1506	2025-10-31 12:07:20.964464	\N	\N	OPTIONS /api/user-org	/api/user-org	OPTIONS	127.0.0.1	404
1511	2025-10-31 12:09:20.816241	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1516	2025-10-31 12:09:32.080711	\N	\N	OPTIONS /api/product-warehouses	/api/product-warehouses	OPTIONS	127.0.0.1	200
1521	2025-10-31 12:10:21.977303	1	1	GET /api/product-warehouses	/api/product-warehouses	GET	127.0.0.1	200
1526	2025-10-31 12:11:20.051928	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1743	2025-10-31 15:16:05.198364	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1745	2025-10-31 15:16:05.26771	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1750	2025-10-31 15:16:50.261243	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1755	2025-10-31 15:17:10.425806	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1762	2025-10-31 15:17:10.555298	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1888	2025-10-31 16:24:39.768455	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1893	2025-10-31 16:24:39.84898	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2105	2025-10-31 18:15:32.270148	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
2356	2025-10-31 19:12:15.543731	\N	\N	POST /api/login	/api/login	POST	127.0.0.1	404
2512	2025-11-05 05:09:52.120132	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2517	2025-11-05 05:09:52.408286	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
2709	2025-11-05 06:48:01.775445	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2714	2025-11-05 06:48:20.956713	\N	\N	OPTIONS /api/suppliers	/api/suppliers	OPTIONS	127.0.0.1	200
2834	2025-11-05 16:04:06.604467	\N	\N	OPTIONS /api/supplier-items	/api/supplier-items	OPTIONS	127.0.0.1	200
2838	2025-11-05 16:04:09.647729	1	1	GET /api/supplier-items	/api/supplier-items	GET	127.0.0.1	200
2934	2025-11-05 16:26:37.135241	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
2935	2025-11-05 16:26:43.674094	1	1	REPORT_NL ok=True rows=1 err=	/api/reports/nl	POST	127.0.0.1	\N
2938	2025-11-05 16:26:53.773343	1	1	REPORT_NL ok=True rows=4 err=	/api/reports/nl	POST	127.0.0.1	\N
2940	2025-11-05 16:26:59.958434	1	1	REPORT_NL ok=True rows=8 err=	/api/reports/nl	POST	127.0.0.1	\N
2942	2025-11-05 16:27:08.446933	1	1	REPORT_NL ok=True rows=0 err=	/api/reports/nl	POST	127.0.0.1	\N
2992	2025-11-05 17:57:43.303028	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
2997	2025-11-05 17:57:50.331215	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
3025	2025-11-05 18:26:30.414892	1	1	REPORT_NL ok=True rows=1 err=	/api/reports/nl	POST	127.0.0.1	\N
3030	2025-11-05 18:27:36.388161	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
3035	2025-11-05 18:27:47.174054	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
3041	2025-11-05 18:28:08.405838	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
3055	2025-11-05 19:28:47.062446	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3060	2025-11-05 19:28:56.70267	\N	\N	OPTIONS /api/reports/nl	/api/reports/nl	OPTIONS	127.0.0.1	200
3066	2025-11-05 19:30:01.676742	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3096	2025-11-05 19:47:54.590513	1	1	GET /api/suppliers	/api/suppliers	GET	127.0.0.1	200
3101	2025-11-05 19:50:21.439034	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
3126	2025-11-07 10:17:25.972766	\N	\N	GET /api/menu	/api/menu	GET	127.0.0.1	401
3129	2025-11-07 10:17:35.704886	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
3136	2025-11-07 10:17:37.470236	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3138	2025-11-07 10:17:38.29231	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
3141	2025-11-07 10:17:41.933162	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
3144	2025-11-07 10:18:18.821558	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
3147	2025-11-07 10:18:47.354322	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
3150	2025-11-07 10:18:51.979864	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
3152	2025-11-07 10:18:56.54244	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
3157	2025-11-07 10:18:56.86405	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
3161	2025-11-07 10:18:58.639298	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
3164	2025-11-07 10:19:08.685768	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
3166	2025-11-07 10:19:08.759573	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
3168	2025-11-07 10:19:15.088868	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3171	2025-11-07 10:19:15.098739	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
3174	2025-11-07 10:19:15.151845	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
3176	2025-11-07 10:19:15.204184	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
3179	2025-11-07 10:19:16.297672	\N	\N	OPTIONS /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	OPTIONS	127.0.0.1	200
3183	2025-11-07 10:19:16.371897	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
3186	2025-11-07 10:19:47.546792	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
3197	2025-11-07 18:08:38.255975	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3204	2025-11-07 18:16:00.202487	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
3216	2025-11-07 18:40:59.173406	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
3219	2025-11-07 18:40:59.252616	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
3222	2025-11-07 18:41:17.218809	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3240	2025-11-07 18:57:41.790261	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3243	2025-11-07 18:57:42.240626	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3246	2025-11-07 18:57:42.452847	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3250	2025-11-07 19:03:12.932209	1	1	GET /api/work-orders/reports/stats	/api/work-orders/reports/stats	GET	127.0.0.1	200
3256	2025-11-07 19:07:59.753524	1	1	GET /api/work-orders/reports/stats	/api/work-orders/reports/stats	GET	127.0.0.1	200
938	2025-10-27 21:24:55.144123	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1499	2025-10-31 12:07:00.448162	1	1	GET /api/roles	/api/roles	GET	127.0.0.1	200
1505	2025-10-31 12:07:19.631195	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1510	2025-10-31 12:09:20.743502	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1515	2025-10-31 12:09:28.284374	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1520	2025-10-31 12:10:21.909169	\N	\N	OPTIONS /api/product-warehouses	/api/product-warehouses	OPTIONS	127.0.0.1	200
1525	2025-10-31 12:11:18.129127	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1744	2025-10-31 15:16:05.201613	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1749	2025-10-31 15:16:50.258243	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
1752	2025-10-31 15:16:50.324511	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
1757	2025-10-31 15:17:10.439859	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
1764	2025-10-31 15:17:10.586895	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
1889	2025-10-31 16:24:39.779452	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1891	2025-10-31 16:24:39.825984	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2107	2025-10-31 18:35:59.927297	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2109	2025-10-31 18:35:59.993036	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2114	2025-10-31 18:36:08.598453	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2117	2025-10-31 18:36:12.81347	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2120	2025-10-31 18:36:40.277196	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
2357	2025-10-31 19:15:04.084238	\N	\N	POST /api/login	/api/login	POST	127.0.0.1	404
2513	2025-11-05 05:09:52.272191	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
2710	2025-11-05 06:48:01.799028	\N	\N	OPTIONS /api/suppliers	/api/suppliers	OPTIONS	127.0.0.1	200
2715	2025-11-05 06:48:20.971698	1	1	GET /api/suppliers	/api/suppliers	GET	127.0.0.1	200
2835	2025-11-05 16:04:06.726426	1	1	GET /api/supplier-items	/api/supplier-items	GET	127.0.0.1	200
2839	2025-11-05 16:04:11.347814	1	1	GET /api/supplier-items	/api/supplier-items	GET	127.0.0.1	200
2936	2025-11-05 16:26:46.092729	1	1	POST /api/reports/nl	/api/reports/nl	POST	127.0.0.1	200
2937	2025-11-05 16:26:50.563209	1	1	POST /api/reports/nl	/api/reports/nl	POST	127.0.0.1	400
2939	2025-11-05 16:26:56.193834	1	1	POST /api/reports/nl	/api/reports/nl	POST	127.0.0.1	200
2941	2025-11-05 16:27:05.164257	1	1	POST /api/reports/nl	/api/reports/nl	POST	127.0.0.1	200
2943	2025-11-05 16:27:10.050323	1	1	POST /api/reports/nl	/api/reports/nl	POST	127.0.0.1	200
2993	2025-11-05 17:57:43.333577	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
3026	2025-11-05 18:26:32.511876	1	1	POST /api/reports/nl	/api/reports/nl	POST	127.0.0.1	200
3031	2025-11-05 18:27:36.449382	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3036	2025-11-05 18:27:47.199641	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3040	2025-11-05 18:28:08.400561	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3067	2025-11-05 19:30:01.734319	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3097	2025-11-05 19:49:51.200213	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
3102	2025-11-05 19:50:21.472202	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
3143	2025-11-07 10:17:45.272702	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
3146	2025-11-07 10:18:47.044651	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
3149	2025-11-07 10:18:49.703677	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
3154	2025-11-07 10:18:56.548975	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
3156	2025-11-07 10:18:56.605863	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
3159	2025-11-07 10:18:58.574837	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
3162	2025-11-07 10:19:08.67787	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
3167	2025-11-07 10:19:08.885189	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
3169	2025-11-07 10:19:15.091026	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
3172	2025-11-07 10:19:15.106626	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
3177	2025-11-07 10:19:15.255829	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
3180	2025-11-07 10:19:16.315271	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
3182	2025-11-07 10:19:16.340558	1	1	GET /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	GET	127.0.0.1	200
3184	2025-11-07 10:19:16.386462	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
3187	2025-11-07 10:19:47.564164	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
3200	2025-11-07 18:08:38.809899	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
3207	2025-11-07 18:32:20.243609	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3208	2025-11-07 18:32:20.273836	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
3209	2025-11-07 18:32:20.498729	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3212	2025-11-07 18:32:20.62289	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
3217	2025-11-07 18:40:59.208327	\N	\N	OPTIONS /api/roles	/api/roles	OPTIONS	127.0.0.1	200
3220	2025-11-07 18:40:59.256073	1	1	GET /api/roles	/api/roles	GET	127.0.0.1	200
3223	2025-11-07 18:41:17.261732	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3241	2025-11-07 18:57:42.066447	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
3247	2025-11-07 18:57:42.724805	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
3251	2025-11-07 19:05:28.073644	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	401
3257	2025-11-07 19:08:37.541065	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3258	2025-11-07 19:08:37.631082	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3260	2025-11-07 19:08:37.677165	\N	\N	GET /api/menu	/api/menu	GET	127.0.0.1	401
3261	2025-11-07 19:08:37.682164	\N	\N	OPTIONS /api/work-orders/reports/stats	/api/work-orders/reports/stats	OPTIONS	127.0.0.1	200
3263	2025-11-07 19:08:48.450103	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
3264	2025-11-07 19:08:48.662956	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
3266	2025-11-07 19:08:50.317988	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
3267	2025-11-07 19:08:50.325326	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
940	2025-10-27 21:24:55.209209	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1513	2025-10-31 12:09:22.876116	1	1	GET /api/product-warehouses	/api/product-warehouses	GET	127.0.0.1	200
1518	2025-10-31 12:09:37.372379	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1523	2025-10-31 12:10:53.441189	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1528	2025-10-31 12:11:27.669645	1	1	GET /api/product-warehouses	/api/product-warehouses	GET	127.0.0.1	200
1746	2025-10-31 15:16:05.271832	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1751	2025-10-31 15:16:50.273428	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
1756	2025-10-31 15:17:10.428799	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1763	2025-10-31 15:17:10.562293	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1890	2025-10-31 16:24:39.781461	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1894	2025-10-31 16:25:57.97561	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
2108	2025-10-31 18:35:59.944301	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2111	2025-10-31 18:36:08.472995	\N	\N	OPTIONS /api/work-orders/2/finish	/api/work-orders/2/finish	OPTIONS	127.0.0.1	200
2113	2025-10-31 18:36:08.59644	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2116	2025-10-31 18:36:08.665584	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2119	2025-10-31 18:36:40.258388	\N	\N	OPTIONS /api/movements	/api/movements	OPTIONS	127.0.0.1	200
2358	2025-10-31 19:16:00.569845	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2359	2025-10-31 19:16:00.606877	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
2365	2025-10-31 19:16:01.087144	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2371	2025-10-31 19:16:31.586523	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
2377	2025-10-31 19:16:31.710264	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
2383	2025-10-31 19:17:56.165744	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2518	2025-11-05 05:09:52.483956	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2712	2025-11-05 06:48:02.079228	1	1	GET /api/supplier-items	/api/supplier-items	GET	127.0.0.1	200
2836	2025-11-05 16:04:09.230265	1	1	GET /api/supplier-items	/api/supplier-items	GET	127.0.0.1	200
2944	2025-11-05 16:36:46.073836	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
2998	2025-11-05 18:05:59.546899	\N	\N	OPTIONS /api/movements	/api/movements	OPTIONS	127.0.0.1	200
3003	2025-11-05 18:06:09.618222	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
3008	2025-11-05 18:09:16.457845	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
3013	2025-11-05 18:09:19.749754	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
3037	2025-11-05 18:28:08.286769	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3068	2025-11-05 19:42:41.373628	\N	\N	OPTIONS /api/reports/nl	/api/reports/nl	OPTIONS	127.0.0.1	200
3073	2025-11-05 19:44:13.607347	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3078	2025-11-05 19:45:37.311097	\N	\N	OPTIONS /api/reports/nl	/api/reports/nl	OPTIONS	127.0.0.1	200
3083	2025-11-05 19:45:56.213259	\N	\N	OPTIONS /api/reports/nl	/api/reports/nl	OPTIONS	127.0.0.1	200
3088	2025-11-05 19:46:04.52611	\N	\N	OPTIONS /api/reports/nl	/api/reports/nl	OPTIONS	127.0.0.1	200
3105	2025-11-05 20:04:40.876811	\N	\N	GET /api/menu	/api/menu	GET	127.0.0.1	401
3165	2025-11-07 10:19:08.724701	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
3170	2025-11-07 10:19:15.093023	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
3173	2025-11-07 10:19:15.133405	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3175	2025-11-07 10:19:15.192197	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
3178	2025-11-07 10:19:16.295143	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
3181	2025-11-07 10:19:16.319026	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
3185	2025-11-07 10:19:16.39933	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
3201	2025-11-07 18:15:59.845264	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
3205	2025-11-07 18:20:37.117656	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
3210	2025-11-07 18:32:20.522818	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
3213	2025-11-07 18:32:21.812829	\N	\N	OPTIONS /api/roles	/api/roles	OPTIONS	127.0.0.1	200
3224	2025-11-07 18:45:09.393671	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3225	2025-11-07 18:45:09.567338	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3226	2025-11-07 18:45:09.626392	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3229	2025-11-07 18:45:09.819552	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
3234	2025-11-07 18:45:18.5268	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3237	2025-11-07 18:45:18.615537	1	1	GET /api/roles	/api/roles	GET	127.0.0.1	200
3242	2025-11-07 18:57:42.180776	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
3245	2025-11-07 18:57:42.449151	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
3252	2025-11-07 19:07:19.682416	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
3253	2025-11-07 19:07:20.045158	1	1	GET /api/work-orders/reports/stats	/api/work-orders/reports/stats	GET	127.0.0.1	200
3259	2025-11-07 19:08:37.650788	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
3262	2025-11-07 19:08:37.747284	\N	\N	GET /api/work-orders/reports/stats	/api/work-orders/reports/stats	GET	127.0.0.1	200
3265	2025-11-07 19:08:50.316519	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3268	2025-11-07 19:08:50.325326	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
3269	2025-11-07 19:08:50.367351	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3271	2025-11-07 19:08:50.468871	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3272	2025-11-07 19:08:51.132929	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
3273	2025-11-07 19:08:51.19441	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
3274	2025-11-07 19:08:52.965109	\N	\N	OPTIONS /api/work-orders/reports/stats	/api/work-orders/reports/stats	OPTIONS	127.0.0.1	200
3275	2025-11-07 19:08:52.992938	1	1	GET /api/work-orders/reports/stats	/api/work-orders/reports/stats	GET	127.0.0.1	200
3276	2025-11-07 19:08:59.998796	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3277	2025-11-07 19:08:59.999816	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
3278	2025-11-07 19:09:00.029521	\N	\N	OPTIONS /api/work-orders/reports/stats	/api/work-orders/reports/stats	OPTIONS	127.0.0.1	200
941	2025-10-27 21:24:55.217405	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
942	2025-10-28 01:37:01.447615	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
943	2025-10-28 01:37:01.600634	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
944	2025-10-28 01:37:17.022539	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
945	2025-10-28 01:37:17.338788	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
946	2025-10-28 01:37:18.885985	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
947	2025-10-28 01:37:18.886985	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
948	2025-10-28 01:37:18.894995	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
949	2025-10-28 01:37:18.896006	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
950	2025-10-28 01:37:18.901281	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
951	2025-10-28 01:37:18.951238	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
952	2025-10-28 01:37:18.952677	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
953	2025-10-28 01:37:18.964051	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
954	2025-10-28 01:37:18.986821	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
955	2025-10-28 01:37:19.057033	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
956	2025-10-28 01:37:28.355354	\N	\N	OPTIONS /api/product-warehouses	/api/product-warehouses	OPTIONS	127.0.0.1	200
957	2025-10-28 01:37:28.411206	1	1	GET /api/product-warehouses	/api/product-warehouses	GET	127.0.0.1	200
958	2025-10-28 01:54:04.803368	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
959	2025-10-28 01:54:04.803368	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
960	2025-10-28 01:54:04.919169	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
961	2025-10-28 01:54:04.9542	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
962	2025-10-28 01:54:04.972876	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
963	2025-10-28 01:54:04.987226	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
964	2025-10-28 20:12:16.37802	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
965	2025-10-28 20:12:16.355656	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
966	2025-10-28 20:12:16.41255	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
967	2025-10-28 20:12:16.442998	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
968	2025-10-28 20:12:16.842359	\N	\N	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	401
969	2025-10-28 20:12:16.852938	\N	\N	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	401
970	2025-10-28 20:12:16.861715	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
971	2025-10-28 20:12:16.996151	\N	\N	GET /api/menu	/api/menu	GET	127.0.0.1	401
972	2025-10-28 20:12:37.785744	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
973	2025-10-28 20:12:38.057773	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
974	2025-10-28 20:12:39.618082	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
975	2025-10-28 20:12:39.623866	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
976	2025-10-28 20:12:39.632252	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
977	2025-10-28 20:12:39.634565	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
978	2025-10-28 20:12:39.635628	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
979	2025-10-28 20:12:39.680672	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
980	2025-10-28 20:12:39.698712	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
981	2025-10-28 20:12:39.704572	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
982	2025-10-28 20:12:39.717701	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
983	2025-10-28 20:12:39.727095	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
984	2025-10-28 20:12:47.769758	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
985	2025-10-28 20:12:47.790804	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
986	2025-10-28 20:12:48.886014	\N	\N	OPTIONS /api/product-warehouses	/api/product-warehouses	OPTIONS	127.0.0.1	200
987	2025-10-28 20:12:48.90722	1	1	GET /api/product-warehouses	/api/product-warehouses	GET	127.0.0.1	200
988	2025-10-28 20:29:21.324442	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
989	2025-10-28 20:29:21.329498	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
990	2025-10-28 20:29:21.347923	\N	\N	OPTIONS /api/product-warehouses	/api/product-warehouses	OPTIONS	127.0.0.1	200
991	2025-10-28 20:29:21.39335	1	1	GET /api/product-warehouses	/api/product-warehouses	GET	127.0.0.1	200
992	2025-10-28 20:29:21.530736	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
993	2025-10-28 20:29:21.536796	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
994	2025-10-28 20:31:11.678108	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
995	2025-10-28 20:31:11.682267	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
996	2025-10-28 20:31:11.713339	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
997	2025-10-28 20:31:11.721606	\N	\N	OPTIONS /api/product-warehouses	/api/product-warehouses	OPTIONS	127.0.0.1	200
998	2025-10-28 20:31:11.727148	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
999	2025-10-28 20:31:11.765337	1	1	GET /api/product-warehouses	/api/product-warehouses	GET	127.0.0.1	200
1000	2025-10-28 20:43:58.958294	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1001	2025-10-28 20:43:58.966109	\N	\N	OPTIONS /api/product-warehouses	/api/product-warehouses	OPTIONS	127.0.0.1	200
1002	2025-10-28 20:43:58.966109	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1003	2025-10-28 20:43:59.040353	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1004	2025-10-28 20:43:59.157623	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1005	2025-10-28 20:43:59.170629	1	1	GET /api/product-warehouses	/api/product-warehouses	GET	127.0.0.1	200
1006	2025-10-28 20:45:20.742805	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1007	2025-10-28 20:45:20.753424	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1008	2025-10-28 20:45:20.778579	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1009	2025-10-28 20:45:20.804734	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1010	2025-10-28 20:45:20.808739	\N	\N	OPTIONS /api/product-warehouses	/api/product-warehouses	OPTIONS	127.0.0.1	200
1011	2025-10-28 20:45:20.856456	1	1	GET /api/product-warehouses	/api/product-warehouses	GET	127.0.0.1	200
1012	2025-10-28 21:18:28.892003	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1013	2025-10-28 21:18:28.91167	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1014	2025-10-28 21:18:28.947962	\N	\N	OPTIONS /api/product-warehouses	/api/product-warehouses	OPTIONS	127.0.0.1	200
1015	2025-10-28 21:18:29.010273	\N	\N	GET /api/product-warehouses	/api/product-warehouses	GET	127.0.0.1	200
1016	2025-10-28 21:18:29.068703	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
1017	2025-10-28 21:18:29.084362	\N	\N	GET /api/menu	/api/menu	GET	127.0.0.1	401
1018	2025-10-28 21:18:40.965996	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
1019	2025-10-28 21:18:41.189848	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
1020	2025-10-28 21:18:42.789122	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1021	2025-10-28 21:18:42.792166	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1022	2025-10-28 21:18:42.795763	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1023	2025-10-28 21:18:42.799887	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
1024	2025-10-28 21:18:42.805345	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1025	2025-10-28 21:18:42.837554	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1026	2025-10-28 21:18:42.856295	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1027	2025-10-28 21:18:42.860998	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1028	2025-10-28 21:18:42.907524	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1029	2025-10-28 21:18:42.968464	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
1030	2025-10-28 21:20:37.661789	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1031	2025-10-28 21:20:37.693713	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1032	2025-10-28 21:20:37.697711	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
1033	2025-10-28 21:20:37.702234	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1034	2025-10-28 21:20:37.710359	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1035	2025-10-28 21:20:37.770584	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1036	2025-10-28 21:20:37.774108	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1037	2025-10-28 21:20:37.779512	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1038	2025-10-28 21:20:37.799672	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
1039	2025-10-28 21:20:54.630931	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1040	2025-10-28 21:20:54.63388	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1041	2025-10-28 21:20:54.636275	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
1042	2025-10-28 21:20:54.639722	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1043	2025-10-28 21:20:54.735283	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1044	2025-10-28 21:20:54.940444	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1045	2025-10-28 21:20:54.969128	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
1046	2025-10-28 21:20:54.980812	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1047	2025-10-28 21:20:55.007501	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1048	2025-10-28 21:21:38.04852	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1049	2025-10-28 21:21:38.052122	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1050	2025-10-28 21:21:38.092297	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
1051	2025-10-28 21:21:38.100892	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1052	2025-10-28 21:21:38.138344	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1053	2025-10-28 21:21:38.176719	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1054	2025-10-28 21:21:38.187394	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1055	2025-10-28 21:21:38.195502	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
1056	2025-10-28 21:21:38.200323	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1057	2025-10-28 21:22:01.945739	\N	\N	OPTIONS /api/product-warehouses	/api/product-warehouses	OPTIONS	127.0.0.1	200
1058	2025-10-28 21:22:01.977526	1	1	GET /api/product-warehouses	/api/product-warehouses	GET	127.0.0.1	200
1059	2025-10-28 21:22:05.776061	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1060	2025-10-28 21:22:05.799662	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1061	2025-10-28 21:22:12.434418	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1062	2025-10-28 21:22:12.46613	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1063	2025-10-28 21:22:20.715616	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
1064	2025-10-28 21:22:20.784299	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1065	2025-10-28 21:22:26.663937	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1066	2025-10-28 21:22:26.709552	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1067	2025-10-28 21:22:27.674014	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
1068	2025-10-28 21:22:27.716794	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1069	2025-10-28 21:24:29.878592	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1070	2025-10-28 21:24:29.896685	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1071	2025-10-28 21:24:29.901258	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
1072	2025-10-28 21:24:29.942214	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1073	2025-10-28 21:24:29.962583	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1074	2025-10-28 21:24:30.061479	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1075	2025-10-28 21:24:35.139027	\N	\N	OPTIONS /api/supplier-items	/api/supplier-items	OPTIONS	127.0.0.1	200
1076	2025-10-28 21:24:35.175744	\N	\N	OPTIONS /api/suppliers	/api/suppliers	OPTIONS	127.0.0.1	200
1077	2025-10-28 21:24:35.175744	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1078	2025-10-28 21:24:35.179989	1	1	GET /api/supplier-items	/api/supplier-items	GET	127.0.0.1	200
1079	2025-10-28 21:24:35.212323	1	1	GET /api/suppliers	/api/suppliers	GET	127.0.0.1	200
1080	2025-10-28 21:24:35.214625	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1084	2025-10-28 21:25:06.26775	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1089	2025-10-28 21:26:06.10162	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1094	2025-10-28 21:26:25.484514	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1099	2025-10-28 21:26:36.744589	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1105	2025-10-28 21:26:42.260171	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
1514	2025-10-31 12:09:28.231854	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1519	2025-10-31 12:09:37.387104	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1524	2025-10-31 12:11:18.060236	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1765	2025-10-31 15:18:26.549334	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1769	2025-10-31 15:18:26.696485	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1774	2025-10-31 15:18:39.206506	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1779	2025-10-31 15:18:51.17852	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1896	2025-10-31 16:27:10.546136	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1900	2025-10-31 16:27:10.773957	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1904	2025-10-31 16:27:27.60923	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1908	2025-10-31 16:27:27.906405	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1912	2025-10-31 16:28:13.52799	\N	\N	OPTIONS /api/work-orders/1/start	/api/work-orders/1/start	OPTIONS	127.0.0.1	200
1915	2025-10-31 16:28:14.058114	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1922	2025-10-31 16:28:40.617949	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1925	2025-10-31 16:28:49.509475	1	1	PUT /api/work-orders/2/finish	/api/work-orders/2/finish	PUT	127.0.0.1	200
1929	2025-10-31 16:28:49.666739	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1933	2025-10-31 16:29:36.462689	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1937	2025-10-31 16:29:45.642694	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1941	2025-10-31 16:29:53.39476	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1946	2025-10-31 16:29:57.471468	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1950	2025-10-31 16:29:59.24854	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1952	2025-10-31 16:30:00.957279	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
2110	2025-10-31 18:36:00.066043	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2112	2025-10-31 18:36:08.528285	1	1	PUT /api/work-orders/2/finish	/api/work-orders/2/finish	PUT	127.0.0.1	200
2115	2025-10-31 18:36:08.654601	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2118	2025-10-31 18:36:12.836486	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2360	2025-10-31 19:16:00.843614	\N	\N	OPTIONS /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	OPTIONS	127.0.0.1	200
2366	2025-10-31 19:16:01.10063	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
2376	2025-10-31 19:16:31.682984	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2382	2025-10-31 19:17:56.130432	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2519	2025-11-05 05:21:55.368101	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2524	2025-11-05 05:21:55.777264	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
2713	2025-11-05 06:48:02.135547	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2837	2025-11-05 16:04:09.614395	1	1	GET /api/supplier-items	/api/supplier-items	GET	127.0.0.1	200
2945	2025-11-05 16:36:55.750517	1	1	POST /api/reports/nl	/api/reports/nl	POST	127.0.0.1	400
2946	2025-11-05 16:37:01.197878	1	1	POST /api/reports/nl	/api/reports/nl	POST	127.0.0.1	400
2947	2025-11-05 16:37:11.633537	1	1	POST /api/reports/nl	/api/reports/nl	POST	127.0.0.1	400
2948	2025-11-05 16:37:17.493979	1	1	POST /api/reports/nl	/api/reports/nl	POST	127.0.0.1	400
2999	2025-11-05 18:05:59.743125	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
3004	2025-11-05 18:06:10.230066	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
3009	2025-11-05 18:09:16.475476	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
3014	2025-11-05 18:09:22.138598	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
3042	2025-11-05 19:18:15.185804	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3069	2025-11-05 19:42:44.354036	1	1	REPORT_NL ok=True rows=8 err=	/api/reports/nl	POST	127.0.0.1	\N
3074	2025-11-05 19:44:13.613886	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
3079	2025-11-05 19:45:40.094387	1	1	REPORT_NL ok=True rows=1 err=	/api/reports/nl	POST	127.0.0.1	\N
3084	2025-11-05 19:45:57.245542	1	1	REPORT_NL ok=True rows=1 err=	/api/reports/nl	POST	127.0.0.1	\N
3089	2025-11-05 19:46:06.256733	1	1	REPORT_NL ok=True rows=10 err=	/api/reports/nl	POST	127.0.0.1	\N
3106	2025-11-05 20:04:44.605238	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
3188	2025-11-07 18:08:12.336303	\N	\N	OPTIONS /api/movements	/api/movements	OPTIONS	127.0.0.1	200
3191	2025-11-07 18:08:36.518302	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
3194	2025-11-07 18:08:38.189177	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
3196	2025-11-07 18:08:38.252409	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
3198	2025-11-07 18:08:38.316322	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3202	2025-11-07 18:15:59.855346	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
3206	2025-11-07 18:20:37.137191	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
3211	2025-11-07 18:32:20.594918	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
3214	2025-11-07 18:32:21.83853	1	1	GET /api/roles	/api/roles	GET	127.0.0.1	200
3227	2025-11-07 18:45:09.634395	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
3230	2025-11-07 18:45:12.738933	\N	\N	OPTIONS /api/roles	/api/roles	OPTIONS	127.0.0.1	200
3232	2025-11-07 18:45:18.4918	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3235	2025-11-07 18:45:18.545298	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
3238	2025-11-07 18:46:07.179135	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
3244	2025-11-07 18:57:42.241654	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
3248	2025-11-07 18:57:42.79371	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
1081	2025-10-28 21:24:46.523108	\N	\N	OPTIONS /api/suppliers	/api/suppliers	OPTIONS	127.0.0.1	200
1086	2025-10-28 21:25:41.541003	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1090	2025-10-28 21:26:06.146328	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1095	2025-10-28 21:26:25.521456	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1100	2025-10-28 21:26:36.774816	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1104	2025-10-28 21:26:42.243545	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1527	2025-10-31 12:11:27.61721	\N	\N	OPTIONS /api/product-warehouses	/api/product-warehouses	OPTIONS	127.0.0.1	200
1766	2025-10-31 15:18:26.580677	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1770	2025-10-31 15:18:26.739898	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1775	2025-10-31 15:18:39.236861	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1780	2025-10-31 15:18:51.234671	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1897	2025-10-31 16:27:10.712082	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1902	2025-10-31 16:27:10.869549	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1907	2025-10-31 16:27:27.873028	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1911	2025-10-31 16:27:28.000865	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1914	2025-10-31 16:28:14.045049	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1918	2025-10-31 16:28:40.375901	\N	\N	OPTIONS /api/work-orders/1/finish	/api/work-orders/1/finish	OPTIONS	127.0.0.1	200
1921	2025-10-31 16:28:40.580506	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1928	2025-10-31 16:28:49.661737	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1932	2025-10-31 16:29:36.437406	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1936	2025-10-31 16:29:45.609483	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1940	2025-10-31 16:29:53.334997	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
1944	2025-10-31 16:29:57.379758	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
1948	2025-10-31 16:29:59.224534	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1954	2025-10-31 16:30:00.995347	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
1958	2025-10-31 16:31:54.340889	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1962	2025-10-31 16:32:00.622134	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
1966	2025-10-31 16:32:00.722404	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
2121	2025-10-31 18:39:37.712778	\N	\N	POST /api/login	/api/login	POST	127.0.0.1	404
2122	2025-10-31 18:41:41.199152	\N	\N	OPTIONS /api/movements	/api/movements	OPTIONS	127.0.0.1	200
2123	2025-10-31 18:41:41.236956	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
2124	2025-10-31 18:42:13.878323	\N	\N	OPTIONS /api/movements	/api/movements	OPTIONS	127.0.0.1	200
2125	2025-10-31 18:42:13.892004	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
2126	2025-10-31 18:42:31.667885	\N	\N	OPTIONS /api/movements	/api/movements	OPTIONS	127.0.0.1	200
2127	2025-10-31 18:42:31.683479	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
2128	2025-10-31 18:42:47.180736	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
2129	2025-10-31 18:42:47.192734	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
2130	2025-10-31 18:42:54.73732	\N	\N	OPTIONS /api/movements	/api/movements	OPTIONS	127.0.0.1	200
2131	2025-10-31 18:42:54.755108	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
2132	2025-10-31 18:42:55.208375	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2133	2025-10-31 18:42:55.247384	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2134	2025-10-31 18:42:56.202105	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
2135	2025-10-31 18:42:56.225101	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
2136	2025-10-31 18:42:58.023558	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
2137	2025-10-31 18:42:58.937863	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2138	2025-10-31 18:42:59.698341	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
2139	2025-10-31 18:43:00.059918	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
2140	2025-10-31 18:43:05.185559	\N	\N	OPTIONS /api/movements	/api/movements	OPTIONS	127.0.0.1	200
2141	2025-10-31 18:43:05.214536	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
2142	2025-10-31 18:43:06.79201	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2143	2025-10-31 18:43:06.822692	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2144	2025-10-31 18:43:09.20334	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
2145	2025-10-31 18:43:09.244097	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
2146	2025-10-31 18:43:10.824181	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
2147	2025-10-31 18:43:10.86676	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
2148	2025-10-31 18:43:19.507703	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2149	2025-10-31 18:43:19.538693	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2151	2025-10-31 18:43:19.639947	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2153	2025-10-31 18:43:21.867836	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
2155	2025-10-31 18:43:21.925995	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
2159	2025-10-31 18:43:24.416488	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2162	2025-10-31 18:43:24.454076	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2167	2025-10-31 18:43:25.843199	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
2169	2025-10-31 18:43:27.688144	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2172	2025-10-31 18:43:27.721724	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2361	2025-10-31 19:16:00.854069	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2364	2025-10-31 19:16:01.041059	1	1	GET /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	GET	127.0.0.1	200
2370	2025-10-31 19:16:31.577525	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2375	2025-10-31 19:16:31.679569	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
2381	2025-10-31 19:16:31.76875	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
2520	2025-11-05 05:21:55.530683	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
2525	2025-11-05 05:21:55.971957	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1082	2025-10-28 21:24:46.561968	1	1	GET /api/suppliers	/api/suppliers	GET	127.0.0.1	200
1087	2025-10-28 21:26:06.086761	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1092	2025-10-28 21:26:06.153731	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1096	2025-10-28 21:26:25.628255	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1101	2025-10-28 21:26:42.110815	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
1106	2025-10-28 21:26:42.277044	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1529	2025-10-31 12:16:24.572737	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1767	2025-10-31 15:18:26.582672	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1771	2025-10-31 15:18:26.749893	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
1776	2025-10-31 15:18:39.270932	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1781	2025-10-31 15:18:51.256484	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
1898	2025-10-31 16:27:10.713083	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1901	2025-10-31 16:27:10.866231	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1905	2025-10-31 16:27:27.612703	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1909	2025-10-31 16:27:27.929808	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1916	2025-10-31 16:28:14.074117	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1919	2025-10-31 16:28:40.448793	1	1	PUT /api/work-orders/1/finish	/api/work-orders/1/finish	PUT	127.0.0.1	200
1923	2025-10-31 16:28:40.635229	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1926	2025-10-31 16:28:49.572811	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1930	2025-10-31 16:28:55.142671	\N	\N	OPTIONS /api/movements	/api/movements	OPTIONS	127.0.0.1	200
1934	2025-10-31 16:29:44.899278	\N	\N	OPTIONS /api/movements	/api/movements	OPTIONS	127.0.0.1	200
1938	2025-10-31 16:29:51.221249	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1942	2025-10-31 16:29:57.370683	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1947	2025-10-31 16:29:57.507711	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
1951	2025-10-31 16:29:59.254245	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1955	2025-10-31 16:31:54.116463	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1959	2025-10-31 16:32:00.599547	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1963	2025-10-31 16:32:00.638276	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2150	2025-10-31 18:43:19.621395	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2152	2025-10-31 18:43:21.865837	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2154	2025-10-31 18:43:21.905004	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2157	2025-10-31 18:43:21.989904	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
2160	2025-10-31 18:43:24.426882	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
2163	2025-10-31 18:43:24.481588	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
2166	2025-10-31 18:43:25.840202	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2168	2025-10-31 18:43:27.68185	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
2171	2025-10-31 18:43:27.719719	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
2362	2025-10-31 19:16:00.856306	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
2368	2025-10-31 19:16:01.11796	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2373	2025-10-31 19:16:31.661076	\N	\N	OPTIONS /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	OPTIONS	127.0.0.1	200
2379	2025-10-31 19:16:31.741977	1	1	GET /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	GET	127.0.0.1	200
2521	2025-11-05 05:21:55.620091	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
2527	2025-11-05 05:21:56.44281	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2716	2025-11-05 15:16:16.34731	\N	\N	OPTIONS /api/supplier-items	/api/supplier-items	OPTIONS	127.0.0.1	200
2719	2025-11-05 15:16:16.738912	\N	\N	GET /api/suppliers	/api/suppliers	GET	127.0.0.1	401
2724	2025-11-05 15:16:29.785288	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2729	2025-11-05 15:16:29.906966	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
2735	2025-11-05 15:16:32.125649	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2740	2025-11-05 15:17:24.892246	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
2745	2025-11-05 15:17:25.046605	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2750	2025-11-05 15:17:27.222476	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2840	2025-11-05 16:06:56.669381	\N	\N	OPTIONS /api/supplier-items/5/set-preferred	/api/supplier-items/5/set-preferred	OPTIONS	127.0.0.1	200
2843	2025-11-05 16:06:56.891656	1	1	GET /api/supplier-items	/api/supplier-items	GET	127.0.0.1	200
2847	2025-11-05 16:07:11.207777	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2851	2025-11-05 16:07:11.28876	1	1	GET /api/supplier-items	/api/supplier-items	GET	127.0.0.1	200
2858	2025-11-05 16:07:34.555913	\N	\N	OPTIONS /api/supplier-items/9/set-preferred	/api/supplier-items/9/set-preferred	OPTIONS	127.0.0.1	200
2861	2025-11-05 16:07:34.759683	1	1	GET /api/supplier-items	/api/supplier-items	GET	127.0.0.1	200
2865	2025-11-05 16:07:44.242775	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2870	2025-11-05 16:07:44.369925	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
2949	2025-11-05 16:37:47.264709	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
2950	2025-11-05 16:37:51.814925	1	1	REPORT_NL ok=True rows=10 err=	/api/reports/nl	POST	127.0.0.1	\N
2952	2025-11-05 16:37:58.129097	1	1	REPORT_NL ok=True rows=10 err=	/api/reports/nl	POST	127.0.0.1	\N
2954	2025-11-05 16:38:01.436249	1	1	REPORT_NL ok=True rows=10 err=	/api/reports/nl	POST	127.0.0.1	\N
2956	2025-11-05 16:38:04.829101	1	1	REPORT_NL ok=True rows=10 err=	/api/reports/nl	POST	127.0.0.1	\N
3000	2025-11-05 18:06:06.457506	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
3005	2025-11-05 18:06:10.800116	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
3010	2025-11-05 18:09:18.470662	\N	\N	OPTIONS /api/movements	/api/movements	OPTIONS	127.0.0.1	200
3015	2025-11-05 18:09:22.193682	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
3043	2025-11-05 19:18:15.191443	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
3070	2025-11-05 19:42:47.441949	1	1	POST /api/reports/nl	/api/reports/nl	POST	127.0.0.1	200
3107	2025-11-05 20:05:06.173702	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1083	2025-10-28 21:25:06.248513	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1088	2025-10-28 21:26:06.089347	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1093	2025-10-28 21:26:25.466005	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1098	2025-10-28 21:26:25.666017	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1103	2025-10-28 21:26:42.123807	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1530	2025-10-31 12:16:24.705192	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1768	2025-10-31 15:18:26.597693	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
1773	2025-10-31 15:18:39.199501	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1778	2025-10-31 15:18:51.173523	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1782	2025-10-31 15:18:51.310623	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1899	2025-10-31 16:27:10.736464	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1903	2025-10-31 16:27:10.871545	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1906	2025-10-31 16:27:27.869837	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1910	2025-10-31 16:27:27.978762	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1913	2025-10-31 16:28:13.859365	1	1	PUT /api/work-orders/1/start	/api/work-orders/1/start	PUT	127.0.0.1	200
1917	2025-10-31 16:28:14.108442	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1920	2025-10-31 16:28:40.578018	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1924	2025-10-31 16:28:49.427558	\N	\N	OPTIONS /api/work-orders/2/finish	/api/work-orders/2/finish	OPTIONS	127.0.0.1	200
1927	2025-10-31 16:28:49.575791	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1931	2025-10-31 16:28:55.177635	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
1935	2025-10-31 16:29:44.923282	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
1939	2025-10-31 16:29:51.321523	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1943	2025-10-31 16:29:57.37468	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
1945	2025-10-31 16:29:57.46433	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
1949	2025-10-31 16:29:59.228531	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1953	2025-10-31 16:30:00.969304	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1956	2025-10-31 16:31:54.161306	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1960	2025-10-31 16:32:00.602543	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1965	2025-10-31 16:32:00.695687	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2156	2025-10-31 18:43:21.972311	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
2158	2025-10-31 18:43:24.412496	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2161	2025-10-31 18:43:24.430294	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
2164	2025-10-31 18:43:24.506821	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
2165	2025-10-31 18:43:25.836203	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
2170	2025-10-31 18:43:27.704163	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2363	2025-10-31 19:16:00.866062	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
2367	2025-10-31 19:16:01.112309	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
2372	2025-10-31 19:16:31.653076	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2380	2025-10-31 19:16:31.762279	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2522	2025-11-05 05:21:55.736749	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
2528	2025-11-05 05:22:53.518134	\N	\N	POST /api/login	/api/login	POST	127.0.0.1	404
2717	2025-11-05 15:16:16.368834	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2722	2025-11-05 15:16:28.003325	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
2727	2025-11-05 15:16:29.798508	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
2732	2025-11-05 15:16:30.040804	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2737	2025-11-05 15:16:32.195246	1	1	GET /api/suppliers	/api/suppliers	GET	127.0.0.1	200
2742	2025-11-05 15:17:24.898347	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2747	2025-11-05 15:17:26.985117	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
2752	2025-11-05 15:17:29.909394	\N	\N	OPTIONS /api/supplier-items/5/set-preferred	/api/supplier-items/5/set-preferred	OPTIONS	127.0.0.1	404
2841	2025-11-05 16:06:56.764539	1	1	PUT /api/supplier-items/5/set-preferred	/api/supplier-items/5/set-preferred	PUT	127.0.0.1	200
2845	2025-11-05 16:07:11.115267	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
2849	2025-11-05 16:07:11.270032	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2852	2025-11-05 16:07:11.313923	1	1	GET /api/suppliers	/api/suppliers	GET	127.0.0.1	200
2855	2025-11-05 16:07:25.573013	1	1	PUT /api/supplier-items/7/set-preferred	/api/supplier-items/7/set-preferred	PUT	127.0.0.1	200
2862	2025-11-05 16:07:44.222363	\N	\N	OPTIONS /api/supplier-items	/api/supplier-items	OPTIONS	127.0.0.1	200
2866	2025-11-05 16:07:44.276271	\N	\N	OPTIONS /api/suppliers	/api/suppliers	OPTIONS	127.0.0.1	200
2868	2025-11-05 16:07:44.350291	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2872	2025-11-05 16:08:10.698134	\N	\N	OPTIONS /api/suppliers	/api/suppliers	OPTIONS	127.0.0.1	200
2951	2025-11-05 16:37:54.082774	1	1	POST /api/reports/nl	/api/reports/nl	POST	127.0.0.1	200
2953	2025-11-05 16:37:58.13272	1	1	POST /api/reports/nl	/api/reports/nl	POST	127.0.0.1	200
2955	2025-11-05 16:38:01.457871	1	1	POST /api/reports/nl	/api/reports/nl	POST	127.0.0.1	200
2957	2025-11-05 16:38:04.842532	1	1	POST /api/reports/nl	/api/reports/nl	POST	127.0.0.1	200
3001	2025-11-05 18:06:06.659105	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
3006	2025-11-05 18:06:13.59493	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
3011	2025-11-05 18:09:18.588417	1	1	GET /api/movements	/api/movements	GET	127.0.0.1	200
3044	2025-11-05 19:18:15.36074	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
3071	2025-11-05 19:42:47.49952	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3076	2025-11-05 19:44:13.676348	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
3081	2025-11-05 19:45:42.435798	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3086	2025-11-05 19:45:59.163185	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3091	2025-11-05 19:46:10.820831	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1085	2025-10-28 21:25:41.529031	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1091	2025-10-28 21:26:06.150777	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1097	2025-10-28 21:26:25.644821	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1102	2025-10-28 21:26:42.116101	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1107	2025-10-29 03:35:40.327213	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1108	2025-10-29 03:35:40.470173	\N	\N	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	401
1109	2025-10-29 03:35:58.636792	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
1110	2025-10-29 03:35:58.948955	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
1111	2025-10-29 03:36:00.544	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1112	2025-10-29 03:36:00.551558	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
1113	2025-10-29 03:36:00.557199	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1114	2025-10-29 03:36:00.625891	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1115	2025-10-29 03:36:00.65494	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1116	2025-10-29 03:36:00.657037	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1117	2025-10-29 03:36:00.67634	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
1118	2025-10-29 03:36:00.688953	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1119	2025-10-29 03:36:00.754905	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1120	2025-10-29 03:36:12.60649	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1121	2025-10-29 03:36:12.633039	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1122	2025-10-29 03:36:17.111745	\N	\N	OPTIONS /api/product-warehouses	/api/product-warehouses	OPTIONS	127.0.0.1	200
1123	2025-10-29 03:36:17.158033	1	1	GET /api/product-warehouses	/api/product-warehouses	GET	127.0.0.1	200
1124	2025-10-29 03:36:21.258315	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1125	2025-10-29 03:36:21.346335	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1126	2025-10-29 03:36:27.504342	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1127	2025-10-29 03:36:27.554291	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1128	2025-10-29 03:36:31.261429	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
1129	2025-10-29 03:36:31.261429	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1130	2025-10-29 03:36:31.276446	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1131	2025-10-29 03:36:31.339779	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1132	2025-10-29 03:36:31.375791	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
1133	2025-10-29 03:36:40.654841	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
1134	2025-10-29 03:36:40.746929	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1135	2025-10-29 03:37:48.415635	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
1136	2025-10-29 03:37:50.494634	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1137	2025-10-29 03:38:35.37213	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
1138	2025-10-29 03:38:35.455312	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1139	2025-10-29 03:39:54.264426	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1140	2025-10-29 03:39:54.268188	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1141	2025-10-29 03:39:54.271157	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
1142	2025-10-29 03:39:54.72718	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1143	2025-10-29 03:39:54.744315	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1144	2025-10-29 03:39:54.749793	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1145	2025-10-29 03:40:56.356598	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1146	2025-10-29 03:40:56.471505	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1147	2025-10-29 03:40:56.496998	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1148	2025-10-29 03:40:56.514525	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
1149	2025-10-29 03:40:56.560881	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1150	2025-10-29 03:40:56.585922	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1151	2025-10-29 03:42:49.650214	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1152	2025-10-29 03:42:49.654369	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1153	2025-10-29 03:42:49.659343	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
1154	2025-10-29 03:42:49.901368	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1155	2025-10-29 03:42:49.909686	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1156	2025-10-29 03:42:49.914143	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1157	2025-10-29 03:43:47.437908	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1158	2025-10-29 03:43:47.442425	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1159	2025-10-29 03:43:47.517207	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
1160	2025-10-29 03:43:47.534484	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1161	2025-10-29 03:43:47.554723	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1162	2025-10-29 03:43:47.605602	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1163	2025-10-29 03:43:50.785661	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1164	2025-10-29 03:43:50.792136	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1165	2025-10-29 03:43:50.828255	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1166	2025-10-29 03:44:00.873748	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
1167	2025-10-29 03:44:00.90459	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
1168	2025-10-29 03:44:00.910076	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1169	2025-10-29 03:44:00.972896	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
1170	2025-10-29 03:44:00.993124	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1171	2025-10-29 03:45:48.188843	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1174	2025-10-29 03:45:48.238316	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1176	2025-10-29 03:45:48.287404	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1179	2025-10-29 03:45:48.329713	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1531	2025-10-31 12:19:38.301788	\N	\N	OPTIONS /api/product-warehouses	/api/product-warehouses	OPTIONS	127.0.0.1	200
1532	2025-10-31 12:19:38.40339	1	1	GET /api/product-warehouses	/api/product-warehouses	GET	127.0.0.1	200
1533	2025-10-31 12:21:54.808889	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1534	2025-10-31 12:21:54.833933	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1535	2025-10-31 12:22:08.588682	\N	\N	OPTIONS /api/product-warehouses	/api/product-warehouses	OPTIONS	127.0.0.1	200
1536	2025-10-31 12:22:08.619015	1	1	GET /api/product-warehouses	/api/product-warehouses	GET	127.0.0.1	200
1537	2025-10-31 12:23:38.162622	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1539	2025-10-31 12:23:38.299764	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1541	2025-10-31 12:23:43.750325	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1545	2025-10-31 12:23:48.820989	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1548	2025-10-31 12:23:48.851267	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1551	2025-10-31 12:23:48.962449	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
1772	2025-10-31 15:18:26.807287	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1777	2025-10-31 15:18:51.170532	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
1957	2025-10-31 16:31:54.286345	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1961	2025-10-31 16:32:00.607548	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1964	2025-10-31 16:32:00.680862	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1968	2025-10-31 16:32:29.379532	1	1	POST /api/work-orders	/api/work-orders	POST	127.0.0.1	400
2173	2025-10-31 18:43:58.514583	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
2174	2025-10-31 18:43:58.603241	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
2178	2025-10-31 18:43:58.686368	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2181	2025-10-31 18:44:00.213706	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
2183	2025-10-31 18:44:00.262919	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2188	2025-10-31 18:44:02.630568	1	1	GET /api/boms	/api/boms	GET	127.0.0.1	200
2191	2025-10-31 18:44:30.455771	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
2369	2025-10-31 19:16:01.183795	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
2374	2025-10-31 19:16:31.675095	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
2378	2025-10-31 19:16:31.736663	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
2523	2025-11-05 05:21:55.756806	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
2529	2025-11-05 05:23:23.807246	\N	\N	POST /api/login	/api/login	POST	127.0.0.1	404
2718	2025-11-05 15:16:16.378379	\N	\N	OPTIONS /api/suppliers	/api/suppliers	OPTIONS	127.0.0.1	200
2723	2025-11-05 15:16:28.188462	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
2728	2025-11-05 15:16:29.90064	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2733	2025-11-05 15:16:32.119637	\N	\N	OPTIONS /api/supplier-items	/api/supplier-items	OPTIONS	127.0.0.1	200
2738	2025-11-05 15:16:32.213972	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2744	2025-11-05 15:17:24.951262	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
2749	2025-11-05 15:17:27.159933	1	1	GET /api/supplier-items	/api/supplier-items	GET	127.0.0.1	200
2842	2025-11-05 16:06:56.854639	\N	\N	OPTIONS /api/supplier-items	/api/supplier-items	OPTIONS	127.0.0.1	200
2846	2025-11-05 16:07:11.185121	\N	\N	OPTIONS /api/supplier-items	/api/supplier-items	OPTIONS	127.0.0.1	200
2850	2025-11-05 16:07:11.278381	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
2854	2025-11-05 16:07:25.54173	\N	\N	OPTIONS /api/supplier-items/7/set-preferred	/api/supplier-items/7/set-preferred	OPTIONS	127.0.0.1	200
2857	2025-11-05 16:07:25.796244	1	1	GET /api/supplier-items	/api/supplier-items	GET	127.0.0.1	200
2860	2025-11-05 16:07:34.675831	\N	\N	OPTIONS /api/supplier-items	/api/supplier-items	OPTIONS	127.0.0.1	200
2864	2025-11-05 16:07:44.240768	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
2869	2025-11-05 16:07:44.353295	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2873	2025-11-05 16:08:10.898713	1	1	GET /api/suppliers	/api/suppliers	GET	127.0.0.1	200
2958	2025-11-05 16:40:35.651027	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
2959	2025-11-05 16:40:41.388816	1	1	REPORT_NL ok=True rows=5 err=	/api/reports/nl	POST	127.0.0.1	\N
2961	2025-11-05 16:40:50.093752	1	1	REPORT_NL ok=True rows=2 err=	/api/reports/nl	POST	127.0.0.1	\N
2963	2025-11-05 16:40:56.491912	1	1	REPORT_NL ok=True rows=5 err=	/api/reports/nl	POST	127.0.0.1	\N
2965	2025-11-05 16:41:01.867492	1	1	REPORT_NL ok=True rows=1 err=	/api/reports/nl	POST	127.0.0.1	\N
3002	2025-11-05 18:06:09.576225	\N	\N	OPTIONS /api/movements	/api/movements	OPTIONS	127.0.0.1	200
3007	2025-11-05 18:06:13.634237	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
3012	2025-11-05 18:09:19.721325	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
3045	2025-11-05 19:18:15.370348	\N	\N	GET /api/menu	/api/menu	GET	127.0.0.1	401
3072	2025-11-05 19:42:47.595156	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3077	2025-11-05 19:44:13.712561	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3082	2025-11-05 19:45:42.540029	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3087	2025-11-05 19:45:59.262527	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3092	2025-11-05 19:46:10.841298	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3108	2025-11-05 20:12:00.968167	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3110	2025-11-05 20:12:01.315255	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3113	2025-11-05 20:12:01.520764	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
3116	2025-11-05 20:12:24.663785	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
3119	2025-11-05 20:12:24.843429	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
3189	2025-11-07 18:08:12.507959	\N	\N	GET /api/movements	/api/movements	GET	127.0.0.1	401
3192	2025-11-07 18:08:38.117003	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1172	2025-10-29 03:45:48.189842	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1175	2025-10-29 03:45:48.242335	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
1538	2025-10-31 12:23:38.255755	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1540	2025-10-31 12:23:43.741049	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
1542	2025-10-31 12:23:43.752327	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
1543	2025-10-31 12:23:43.783735	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1546	2025-10-31 12:23:48.822991	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1550	2025-10-31 12:23:48.946873	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1553	2025-10-31 12:25:05.153827	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1783	2025-10-31 15:59:56.055602	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1789	2025-10-31 15:59:56.50531	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1794	2025-10-31 16:00:14.211745	\N	\N	OPTIONS /api/movements	/api/movements	OPTIONS	127.0.0.1	200
1799	2025-10-31 16:00:36.518375	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1805	2025-10-31 16:00:46.287485	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
1967	2025-10-31 16:32:29.320048	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2175	2025-10-31 18:43:58.641993	\N	\N	OPTIONS /api/units	/api/units	OPTIONS	127.0.0.1	200
2180	2025-10-31 18:44:00.208477	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2184	2025-10-31 18:44:00.282917	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
2187	2025-10-31 18:44:02.616746	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2190	2025-10-31 18:44:30.433272	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2384	2025-11-03 03:51:55.086179	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
2392	2025-11-03 03:51:55.18264	\N	\N	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	401
2398	2025-11-03 03:52:13.332034	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
2405	2025-11-03 03:52:13.707025	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
2526	2025-11-05 05:21:56.336155	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
2720	2025-11-05 15:16:17.086578	\N	\N	GET /api/supplier-items	/api/supplier-items	GET	127.0.0.1	200
2725	2025-11-05 15:16:29.787287	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
2731	2025-11-05 15:16:29.951799	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
2736	2025-11-05 15:16:32.188711	1	1	GET /api/supplier-items	/api/supplier-items	GET	127.0.0.1	200
2741	2025-11-05 15:17:24.895905	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
2746	2025-11-05 15:17:26.980268	\N	\N	OPTIONS /api/supplier-items	/api/supplier-items	OPTIONS	127.0.0.1	200
2751	2025-11-05 15:17:27.251077	1	1	GET /api/suppliers	/api/suppliers	GET	127.0.0.1	200
2844	2025-11-05 16:07:11.090182	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2848	2025-11-05 16:07:11.217141	\N	\N	OPTIONS /api/suppliers	/api/suppliers	OPTIONS	127.0.0.1	200
2853	2025-11-05 16:07:11.325334	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
2856	2025-11-05 16:07:25.762272	\N	\N	OPTIONS /api/supplier-items	/api/supplier-items	OPTIONS	127.0.0.1	200
2859	2025-11-05 16:07:34.584634	1	1	PUT /api/supplier-items/9/set-preferred	/api/supplier-items/9/set-preferred	PUT	127.0.0.1	200
2863	2025-11-05 16:07:44.230071	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
2867	2025-11-05 16:07:44.309522	1	1	GET /api/supplier-items	/api/supplier-items	GET	127.0.0.1	200
2871	2025-11-05 16:07:44.395595	1	1	GET /api/suppliers	/api/suppliers	GET	127.0.0.1	200
2960	2025-11-05 16:40:46.584377	1	1	POST /api/reports/nl	/api/reports/nl	POST	127.0.0.1	200
2962	2025-11-05 16:40:52.293977	1	1	POST /api/reports/nl	/api/reports/nl	POST	127.0.0.1	200
2964	2025-11-05 16:40:58.822577	1	1	POST /api/reports/nl	/api/reports/nl	POST	127.0.0.1	200
2966	2025-11-05 16:41:03.085113	1	1	POST /api/reports/nl	/api/reports/nl	POST	127.0.0.1	200
3016	2025-11-05 18:19:41.036637	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3019	2025-11-05 18:19:41.125512	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
3046	2025-11-05 19:18:15.56508	\N	\N	GET /api/subscription	/api/subscription	GET	127.0.0.1	401
3075	2025-11-05 19:44:13.661209	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3080	2025-11-05 19:45:42.38729	1	1	POST /api/reports/nl	/api/reports/nl	POST	127.0.0.1	200
3085	2025-11-05 19:45:59.107997	1	1	POST /api/reports/nl	/api/reports/nl	POST	127.0.0.1	200
3090	2025-11-05 19:46:10.797618	1	1	POST /api/reports/nl	/api/reports/nl	POST	127.0.0.1	200
3109	2025-11-05 20:12:01.307825	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
3112	2025-11-05 20:12:01.477535	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
3115	2025-11-05 20:12:24.649364	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
3118	2025-11-05 20:12:24.799108	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
3190	2025-11-07 18:08:36.070175	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
3193	2025-11-07 18:08:38.119012	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
3195	2025-11-07 18:08:38.19856	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
3199	2025-11-07 18:08:38.701147	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
3203	2025-11-07 18:16:00.186817	1	1	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
3215	2025-11-07 18:40:59.148027	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3218	2025-11-07 18:40:59.214384	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3221	2025-11-07 18:41:17.205117	\N	\N	OPTIONS /api/user-org	/api/user-org	OPTIONS	127.0.0.1	404
3228	2025-11-07 18:45:09.645256	\N	\N	OPTIONS /api/user-org	/api/user-org	OPTIONS	127.0.0.1	404
3231	2025-11-07 18:45:12.75906	1	1	GET /api/roles	/api/roles	GET	127.0.0.1	200
3233	2025-11-07 18:45:18.4918	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
3236	2025-11-07 18:45:18.599999	\N	\N	OPTIONS /api/roles	/api/roles	OPTIONS	127.0.0.1	200
3239	2025-11-07 18:46:19.536122	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
3249	2025-11-07 19:03:12.75713	\N	\N	OPTIONS /api/work-orders/reports/stats	/api/work-orders/reports/stats	OPTIONS	127.0.0.1	200
3254	2025-11-07 19:07:59.679574	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
3255	2025-11-07 19:07:59.729804	1	1	GET /api/work-orders/reports/stats	/api/work-orders/reports/stats	GET	127.0.0.1	200
3270	2025-11-07 19:08:50.394978	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1173	2025-10-29 03:45:48.235069	\N	\N	OPTIONS /api/boms	/api/boms	OPTIONS	127.0.0.1	200
1177	2025-10-29 03:45:48.291834	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1178	2025-10-29 03:45:48.317673	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
1180	2025-10-29 03:46:00.831071	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
1181	2025-10-29 03:46:00.941884	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1182	2025-10-29 03:46:00.971522	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
1183	2025-10-29 03:46:00.979586	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1184	2025-10-29 03:46:01.014475	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1185	2025-10-29 03:46:01.046611	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1186	2025-10-29 03:46:01.06454	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
1187	2025-10-29 03:46:05.308293	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1188	2025-10-29 03:46:05.315879	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1189	2025-10-29 03:46:05.368219	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1190	2025-10-29 03:46:05.376698	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1191	2025-10-29 03:46:05.479006	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1192	2025-10-29 03:46:05.488198	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1193	2025-10-29 03:46:05.52125	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
1194	2025-10-29 03:46:10.404737	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1195	2025-10-29 03:46:10.407983	\N	\N	OPTIONS /api/supplier-items	/api/supplier-items	OPTIONS	127.0.0.1	200
1196	2025-10-29 03:46:10.41908	\N	\N	OPTIONS /api/suppliers	/api/suppliers	OPTIONS	127.0.0.1	200
1197	2025-10-29 03:46:10.487595	1	1	GET /api/supplier-items	/api/supplier-items	GET	127.0.0.1	200
1198	2025-10-29 03:46:10.498914	1	1	GET /api/suppliers	/api/suppliers	GET	127.0.0.1	200
1199	2025-10-29 03:46:10.506741	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1200	2025-10-29 03:46:31.469309	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1201	2025-10-29 03:46:31.540707	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1202	2025-10-29 03:46:35.996655	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
1203	2025-10-29 03:46:36.061827	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1204	2025-10-29 03:46:47.552843	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1205	2025-10-29 03:46:47.578938	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1206	2025-10-29 03:46:49.593178	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1207	2025-10-29 03:46:49.627192	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1208	2025-10-29 03:46:57.844679	\N	\N	OPTIONS /api/suppliers	/api/suppliers	OPTIONS	127.0.0.1	200
1209	2025-10-29 03:46:57.871061	1	1	GET /api/suppliers	/api/suppliers	GET	127.0.0.1	200
1210	2025-10-29 15:29:18.370197	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
1211	2025-10-29 15:29:18.622472	\N	\N	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	401
1212	2025-10-29 15:29:44.728634	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
1213	2025-10-29 15:29:45.173836	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
1214	2025-10-29 15:29:46.7626	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1215	2025-10-29 15:29:46.767839	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1216	2025-10-29 15:29:46.842646	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
1217	2025-10-29 15:29:46.863932	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1218	2025-10-29 15:29:46.893859	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1219	2025-10-29 15:29:46.902741	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1220	2025-10-29 15:29:46.941259	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1221	2025-10-29 15:29:46.964971	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
1222	2025-10-29 15:29:46.968446	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1223	2025-10-29 15:29:49.138148	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1224	2025-10-29 15:29:49.159368	1	1	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	200
1225	2025-10-29 15:29:52.617667	\N	\N	OPTIONS /api/products	/api/products	OPTIONS	127.0.0.1	200
1226	2025-10-29 15:29:52.786869	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1227	2025-10-29 16:51:20.777847	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
1228	2025-10-29 16:51:21.188916	\N	\N	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	401
1229	2025-10-29 16:51:30.510285	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
1230	2025-10-29 16:51:30.810725	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
1231	2025-10-29 16:51:32.469088	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
1232	2025-10-29 16:51:32.471249	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
1233	2025-10-29 16:51:32.471249	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
1234	2025-10-29 16:51:32.480275	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
1235	2025-10-29 16:51:32.544297	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
1236	2025-10-29 16:51:32.5588	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1237	2025-10-29 16:51:32.66673	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
1238	2025-10-29 16:51:32.728475	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
1239	2025-10-29 16:51:32.854877	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
1240	2025-10-29 16:51:34.125811	\N	\N	OPTIONS /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	OPTIONS	127.0.0.1	200
1241	2025-10-29 16:51:34.176628	1	1	GET /api/stocks/reorder-suggestions	/api/stocks/reorder-suggestions	GET	127.0.0.1	200
1544	2025-10-31 12:23:43.889097	1	1	GET /api/units	/api/units	GET	127.0.0.1	200
1547	2025-10-31 12:23:48.849269	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
1549	2025-10-31 12:23:48.888447	1	1	GET /api/products	/api/products	GET	127.0.0.1	200
1552	2025-10-31 12:25:05.129828	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
1784	2025-10-31 15:59:56.055602	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
3279	2025-11-07 19:09:00.060079	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3283	2025-11-07 19:11:19.30105	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
3287	2025-11-07 19:11:19.862284	1	1	GET /api/work-orders/reports/stats	/api/work-orders/reports/stats	GET	127.0.0.1	200
3281	2025-11-07 19:09:00.088771	1	1	GET /api/work-orders/reports/stats	/api/work-orders/reports/stats	GET	127.0.0.1	200
3285	2025-11-07 19:11:19.469297	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3289	2025-11-07 19:11:43.065118	1	1	GET /api/work-orders/reports/stats	/api/work-orders/reports/stats	GET	127.0.0.1	200
3282	2025-11-07 19:11:19.298049	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3286	2025-11-07 19:11:19.548431	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
3284	2025-11-07 19:11:19.310347	\N	\N	OPTIONS /api/work-orders/reports/stats	/api/work-orders/reports/stats	OPTIONS	127.0.0.1	200
3288	2025-11-07 19:11:42.990084	\N	\N	OPTIONS /api/work-orders/reports/stats	/api/work-orders/reports/stats	OPTIONS	127.0.0.1	200
3290	2025-11-07 19:13:24.452802	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
3291	2025-11-07 19:13:24.518689	1	1	GET /api/work-orders/reports/stats	/api/work-orders/reports/stats	GET	127.0.0.1	200
3292	2025-11-07 19:13:24.544234	1	1	GET /api/work-orders/reports/stats	/api/work-orders/reports/stats	GET	127.0.0.1	200
3293	2025-11-07 19:16:37.96038	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3294	2025-11-07 19:16:38.298386	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3295	2025-11-07 19:16:38.388331	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
3296	2025-11-07 19:16:38.401537	\N	\N	OPTIONS /api/work-orders/reports/stats	/api/work-orders/reports/stats	OPTIONS	127.0.0.1	200
3297	2025-11-07 19:16:38.543845	1	1	GET /api/work-orders/reports/stats	/api/work-orders/reports/stats	GET	127.0.0.1	200
3298	2025-11-07 19:16:38.563306	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
3299	2025-11-07 19:19:12.604807	\N	\N	OPTIONS /api/work-orders/reports/stats	/api/work-orders/reports/stats	OPTIONS	127.0.0.1	200
3300	2025-11-07 19:19:12.695886	1	1	GET /api/work-orders/reports/stats	/api/work-orders/reports/stats	GET	127.0.0.1	200
3301	2025-11-07 19:24:21.841688	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3302	2025-11-07 19:24:21.842609	\N	\N	OPTIONS /api/user-org	/api/user-org	OPTIONS	127.0.0.1	404
3303	2025-11-07 19:24:21.990279	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3304	2025-11-07 19:26:51.265184	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3305	2025-11-07 19:26:51.269902	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
3306	2025-11-07 19:26:51.32509	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3307	2025-11-07 19:26:51.405253	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
3308	2025-11-07 19:26:51.43966	\N	\N	OPTIONS /api/user-org	/api/user-org	OPTIONS	127.0.0.1	404
3309	2025-11-07 19:26:51.484024	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3310	2025-11-07 19:27:45.37165	\N	\N	OPTIONS /api/roles	/api/roles	OPTIONS	127.0.0.1	200
3311	2025-11-07 19:27:45.407544	1	1	GET /api/roles	/api/roles	GET	127.0.0.1	200
3312	2025-11-07 19:28:03.803488	\N	\N	OPTIONS /api/user-org	/api/user-org	OPTIONS	127.0.0.1	404
3313	2025-11-07 19:28:03.813565	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3314	2025-11-07 19:28:03.837285	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3315	2025-11-07 19:59:06.518691	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
3316	2025-11-07 19:59:06.524217	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3317	2025-11-07 19:59:06.556718	\N	\N	OPTIONS /api/roles	/api/roles	OPTIONS	127.0.0.1	200
3318	2025-11-07 19:59:06.565251	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
3319	2025-11-07 19:59:06.61855	1	1	GET /api/roles	/api/roles	GET	127.0.0.1	200
3320	2025-11-07 19:59:06.634922	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
3321	2025-11-07 19:59:06.639937	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3322	2025-11-07 19:59:06.665681	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
3323	2025-11-07 19:59:06.790575	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3324	2025-11-07 20:00:18.488107	\N	\N	OPTIONS /api/roles	/api/roles	OPTIONS	127.0.0.1	200
3325	2025-11-07 20:00:18.505018	1	1	GET /api/roles	/api/roles	GET	127.0.0.1	200
3326	2025-11-07 20:01:25.771478	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
3327	2025-11-07 20:01:25.781241	\N	\N	OPTIONS /api/roles	/api/roles	OPTIONS	127.0.0.1	200
3328	2025-11-07 20:01:25.786887	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3329	2025-11-07 20:01:25.800469	1	1	GET /api/roles	/api/roles	GET	127.0.0.1	200
3330	2025-11-07 20:01:25.820522	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
3331	2025-11-07 20:01:25.832585	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3332	2025-11-07 20:09:00.172776	\N	\N	OPTIONS /api/work-orders/reports/stats	/api/work-orders/reports/stats	OPTIONS	127.0.0.1	200
3333	2025-11-07 20:09:00.504293	\N	\N	GET /api/work-orders/reports/stats	/api/work-orders/reports/stats	GET	127.0.0.1	200
3334	2025-11-07 20:09:05.789545	\N	\N	OPTIONS /api/warehouses	/api/warehouses	OPTIONS	127.0.0.1	200
3335	2025-11-07 20:09:05.795233	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
3336	2025-11-07 20:09:05.824225	\N	\N	GET /api/warehouses	/api/warehouses	GET	127.0.0.1	401
3337	2025-11-07 20:09:05.849778	\N	\N	GET /api/users	/api/users	GET	127.0.0.1	200
3338	2025-11-07 20:09:05.901791	\N	\N	OPTIONS /api/work-orders	/api/work-orders	OPTIONS	127.0.0.1	200
3339	2025-11-07 20:09:05.907569	\N	\N	OPTIONS /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	OPTIONS	127.0.0.1	200
3340	2025-11-07 20:09:05.991143	\N	\N	GET /api/boms/products-with-active-bom	/api/boms/products-with-active-bom	GET	127.0.0.1	200
3341	2025-11-07 20:09:06.044947	\N	\N	GET /api/work-orders	/api/work-orders	GET	127.0.0.1	200
3342	2025-11-07 20:13:00.743825	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
3343	2025-11-07 20:13:01.153208	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
3344	2025-11-07 20:13:02.708791	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3345	2025-11-07 20:13:02.712812	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
3346	2025-11-07 20:13:02.758675	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3347	2025-11-07 20:13:02.785509	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
3348	2025-11-07 20:13:02.79061	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
3349	2025-11-07 20:13:02.815454	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
3350	2025-11-07 20:13:02.81966	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3351	2025-11-07 20:13:03.264807	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
3352	2025-11-07 20:13:03.298865	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
3353	2025-11-07 20:13:05.823997	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
3354	2025-11-07 20:13:05.847614	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3355	2025-11-07 20:13:05.891566	\N	\N	OPTIONS /api/roles	/api/roles	OPTIONS	127.0.0.1	200
3356	2025-11-07 20:13:05.922091	1	1	GET /api/roles	/api/roles	GET	127.0.0.1	200
3358	2025-11-07 20:13:28.324549	\N	\N	OPTIONS /api/users/5	/api/users/5	OPTIONS	127.0.0.1	200
3361	2025-11-07 20:13:28.558876	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
3363	2025-11-07 20:14:04.348664	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
3369	2025-11-07 20:14:04.627681	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3360	2025-11-07 20:13:28.46165	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
3362	2025-11-07 20:14:04.122046	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
3365	2025-11-07 20:14:04.363872	\N	\N	OPTIONS /api/roles	/api/roles	OPTIONS	127.0.0.1	200
3364	2025-11-07 20:14:04.361874	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3366	2025-11-07 20:14:04.42467	1	1	GET /api/roles	/api/roles	GET	127.0.0.1	200
3367	2025-11-07 20:14:04.495616	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3368	2025-11-07 20:14:04.623685	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
3370	2025-11-07 20:14:04.926485	1	1	GET /api/users	/api/users	GET	127.0.0.1	200
3371	2025-11-08 20:37:14.293913	\N	\N	OPTIONS /api/users	/api/users	OPTIONS	127.0.0.1	200
3372	2025-11-08 20:37:14.700545	\N	\N	GET /api/users	/api/users	GET	127.0.0.1	401
3373	2025-11-08 20:37:18.190997	\N	\N	GET /api/users	/api/users	GET	127.0.0.1	401
3374	2025-11-08 20:37:39.580257	\N	\N	OPTIONS /api/auth/login	/api/auth/login	OPTIONS	127.0.0.1	200
3375	2025-11-08 20:37:40.056745	\N	\N	POST /api/auth/login	/api/auth/login	POST	127.0.0.1	200
3376	2025-11-08 20:37:41.799679	\N	\N	OPTIONS /api/subscription	/api/subscription	OPTIONS	127.0.0.1	200
3377	2025-11-08 20:37:41.840531	\N	\N	OPTIONS /api/menu	/api/menu	OPTIONS	127.0.0.1	200
3378	2025-11-08 20:37:41.877359	\N	\N	OPTIONS /api/dashboard/kpis	/api/dashboard/kpis	OPTIONS	127.0.0.1	200
3379	2025-11-08 20:37:41.891361	\N	\N	OPTIONS /api/stocks/low	/api/stocks/low	OPTIONS	127.0.0.1	200
3380	2025-11-08 20:37:41.991114	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3381	2025-11-08 20:37:42.038268	1	1	GET /api/menu	/api/menu	GET	127.0.0.1	200
3382	2025-11-08 20:37:42.103303	1	1	GET /api/subscription	/api/subscription	GET	127.0.0.1	200
3383	2025-11-08 20:37:43.187702	1	1	GET /api/stocks/low	/api/stocks/low	GET	127.0.0.1	200
3384	2025-11-08 20:37:43.204598	1	1	GET /api/dashboard/kpis	/api/dashboard/kpis	GET	127.0.0.1	200
\.


--
-- TOC entry 5249 (class 0 OID 30721)
-- Dependencies: 220
-- Data for Name: unit; Type: TABLE DATA; Schema: public; Owner: -
--

COPY mrp.unit (id, code, description) FROM stdin;
1	EA	Unidad
2	KG	Kilogramo
3	M	Metro
4	L	Litro
5	BOX	Caja
6	M2	Metro cuadrado
7	M3	Metro cúbico
8	PAL	Pallet
\.


--
-- TOC entry 5261 (class 0 OID 30935)
-- Dependencies: 232
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: -
--

COPY mrp."user" (id, name, email, password, photo, status) FROM stdin;
1	Marcelo Jimenez	marcelojp03@gmail.com	scrypt:32768:8:1$meoFdDDTVQdrLwcc$92ddfeef2df2ce3257a46414818340e8bffd4b2e09611fa78d2d395f43e1d2e94b194bbbbe183dcf2a34915a7ca4f5f5856a00196fd092cf56580119d3a4361d	\N	t
4	Camila Aguilera	camilaal861@gmail.com	scrypt:32768:8:1$dqGzGBes3jRas8no$c70f0a7ed5a2c049a7198c40bece4a671eac7bff37fd91f8251550c605026d15bd23f8a99b0cb103a35e634b0505f45dff013af93603071780d98de3aade3a6c	\N	t
6	Usuario de Prueba	test@test.com	scrypt:32768:8:1$0fk5wGTmGtdGTOAD$13c018201369185c4a318c94ad3da0d29788c9892eebba06beaa2c2dc150640ef9e23af9974e7ad83e6d70eeb63419ce3194c1ef11bf31d0fbc2493089f3964c	\N	t
7	Test Admin	admin_592@test.com	scrypt:32768:8:1$otYxjbbnTFCvGmWF$0350e9eb0e6cc59375fd4cb6e3a6a081f68b5c08e8bc7a2c23ea16b171aa135c53f1183cb3c7bc1c27900bc54287a9c1a52da16bcebfb016c8c20619520bd73d	\N	t
5	Claudia Tapia	claudiatapia00@icloud.com	scrypt:32768:8:1$ttKxTAC7tbZHOKwK$086396b5760bcd6f2468071c44be3f01fc0cd64178f390b2e4feef84b239a38446599ed0c48e030ff29d668c654550b45670ef3338ebdfdc8e20de901e398e12	\N	t
\.


--
-- TOC entry 5272 (class 0 OID 31087)
-- Dependencies: 243
-- Data for Name: user_organization; Type: TABLE DATA; Schema: public; Owner: -
--

COPY mrp.user_organization (user_id, org_id, is_default, created_at, updated_at) FROM stdin;
1	1	t	2025-09-22 10:46:28.820522	2025-09-22 10:46:28.820522
7	3	t	2025-10-24 14:10:44.819654	2025-10-24 14:10:44.819654
4	1	f	2025-10-27 15:58:34.439536	2025-10-27 15:58:34.439536
5	1	f	2025-10-27 15:58:34.439536	2025-10-27 15:58:34.439536
6	1	f	2025-10-27 15:58:34.439536	2025-10-27 15:58:34.439536
\.


--
-- TOC entry 5266 (class 0 OID 30965)
-- Dependencies: 237
-- Data for Name: user_role; Type: TABLE DATA; Schema: public; Owner: -
--

COPY mrp.user_role (role_id, user_id) FROM stdin;
1	1
2	4
1	6
1	7
1	5
\.


--
-- TOC entry 5255 (class 0 OID 30794)
-- Dependencies: 226
-- Data for Name: warehouse; Type: TABLE DATA; Schema: public; Owner: -
--

COPY mrp.warehouse (id, name, location, org_id, created_at, updated_at) FROM stdin;
1	Almacén Central	Av. Principal 123, Santa Cruz	1	\N	\N
2	Almacén Norte	Zona Industrial Norte, Santa Cruz	1	\N	\N
3	Almacén de Materia Prima	Parque Industrial km 7, Santa Cruz	1	\N	\N
4	Almacén de Producto Terminado	Centro Logístico, Santa Cruz	1	\N	\N
5	Almacén de Consumibles	Depósito Central, Santa Cruz	1	\N	\N
\.


--
-- TOC entry 5294 (class 0 OID 38855)
-- Dependencies: 265
-- Data for Name: work_order; Type: TABLE DATA; Schema: public; Owner: -
--

COPY mrp.work_order (id, org_id, product_id, bom_id, quantity, status, warehouse_id, assigned_to, reference, notes, planned_start, planned_end, actual_start, actual_end, created_at, updated_at, created_by) FROM stdin;
1	1	124	1	10.00	Finalizada	\N	1	WO-2025-001	Orden finalizada - Cliente XYZ	2025-10-31 09:37:26.136826	2025-11-04 09:37:26.136826	2025-10-31 09:37:26.136826	2025-11-04 02:37:26.136826	2025-11-07 09:37:26.141	2025-11-07 09:37:26.141	1
2	1	125	2	5.00	Finalizada	1	4	WO-2025-002	Producción completada	2025-10-28 09:37:26.136826	2025-11-02 09:37:26.136826	2025-10-28 09:37:26.136826	2025-11-01 23:37:26.136826	2025-11-07 09:37:26.141	2025-11-07 09:37:26.141	4
3	1	127	3	8.00	Finalizada	\N	1	WO-2025-003	Orden urgente completada	2025-11-01 09:37:26.136826	2025-11-05 09:37:26.136826	2025-11-01 09:37:26.136826	2025-11-05 02:37:26.136826	2025-11-07 09:37:26.141	2025-11-07 09:37:26.141	1
4	1	129	4	12.00	En Progreso	1	4	WO-2025-004	En producción - Cliente ABC	2025-11-05 09:37:26.136826	2025-11-10 09:37:26.136826	2025-11-05 09:37:26.136826	\N	2025-11-07 09:37:26.141	2025-11-07 09:37:26.141	4
5	1	131	5	6.00	En Progreso	\N	5	WO-2025-005	Orden en proceso	2025-11-06 09:37:26.136826	2025-11-09 09:37:26.136826	2025-11-06 09:37:26.136826	\N	2025-11-07 09:37:26.141	2025-11-07 09:37:26.141	5
6	1	133	6	15.00	En Progreso	1	1	WO-2025-006	Producción prioritaria	2025-11-07 09:37:26.136826	2025-11-11 09:37:26.136826	2025-11-07 09:37:26.136826	\N	2025-11-07 09:37:26.141	2025-11-07 09:37:26.141	1
7	1	130	7	20.00	Planificada	\N	4	WO-2025-007	Orden programada próxima semana	2025-11-12 09:37:26.136826	2025-11-16 09:37:26.136826	\N	\N	2025-11-07 09:37:26.141	2025-11-07 09:37:26.141	4
8	1	132	8	10.00	Planificada	1	1	WO-2025-008	Producción stock	2025-11-10 09:37:26.136826	2025-11-14 09:37:26.136826	\N	\N	2025-11-07 09:37:26.141	2025-11-07 09:37:26.141	1
9	1	136	9	25.00	Planificada	\N	5	WO-2025-009	Orden gran volumen	2025-11-14 09:37:26.136826	2025-11-21 09:37:26.136826	\N	\N	2025-11-07 09:37:26.141	2025-11-07 09:37:26.141	5
10	1	134	10	8.00	Planificada	1	4	WO-2025-010	Cliente preferencial	2025-11-17 09:37:26.136826	2025-11-22 09:37:26.136826	\N	\N	2025-11-07 09:37:26.141	2025-11-07 09:37:26.141	4
11	1	124	1	12.00	Planificada	\N	1	WO-2025-011	Reposición stock	2025-11-21 09:37:26.136826	2025-11-27 09:37:26.136826	\N	\N	2025-11-07 09:37:26.141	2025-11-07 09:37:26.141	1
12	1	125	2	5.00	Cancelada	1	4	WO-2025-012	Cancelada por cliente	2025-11-08 09:37:26.136826	2025-11-12 09:37:26.136826	\N	\N	2025-11-07 09:37:26.141	2025-11-07 09:37:26.141	4
13	1	127	3	3.00	Cancelada	\N	1	WO-2025-013	Falta de material	2025-11-09 09:37:26.136826	2025-11-13 09:37:26.136826	\N	\N	2025-11-07 09:37:26.141	2025-11-07 09:37:26.141	1
14	1	129	4	18.00	Planificada	1	5	WO-2025-014	Orden próximo mes	2025-11-28 09:37:26.136826	2025-12-05 09:37:26.136826	\N	\N	2025-11-07 09:37:26.141	2025-11-07 09:37:26.141	5
15	1	131	5	30.00	Planificada	\N	4	WO-2025-015	Producción futura - Cliente Premium	2025-12-07 09:37:26.136826	2025-12-17 09:37:26.136826	\N	\N	2025-11-07 09:37:26.141	2025-11-07 09:37:26.141	4
\.


--
-- TOC entry 5339 (class 0 OID 0)
-- Dependencies: 262
-- Name: bom_component_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('mrp.bom_component_id_seq', 29, true);


--
-- TOC entry 5340 (class 0 OID 0)
-- Dependencies: 260
-- Name: bom_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('mrp.bom_id_seq', 10, true);


--
-- TOC entry 5341 (class 0 OID 0)
-- Dependencies: 258
-- Name: category_categoryid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('mrp.category_categoryid_seq', 1, false);


--
-- TOC entry 5342 (class 0 OID 0)
-- Dependencies: 244
-- Name: drawer_drawerid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('mrp.drawer_drawerid_seq', 1, false);


--
-- TOC entry 5343 (class 0 OID 0)
-- Dependencies: 240
-- Name: movement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('mrp.movement_id_seq', 64, true);


--
-- TOC entry 5344 (class 0 OID 0)
-- Dependencies: 256
-- Name: org_subscription_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('mrp.org_subscription_id_seq', 3, true);


--
-- TOC entry 5345 (class 0 OID 0)
-- Dependencies: 217
-- Name: organization_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('mrp.organization_id_seq', 5, true);


--
-- TOC entry 5346 (class 0 OID 0)
-- Dependencies: 248
-- Name: plan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('mrp.plan_id_seq', 9, true);


--
-- TOC entry 5347 (class 0 OID 0)
-- Dependencies: 223
-- Name: product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('mrp.product_id_seq', 138, true);


--
-- TOC entry 5348 (class 0 OID 0)
-- Dependencies: 227
-- Name: product_warehouse_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('mrp.product_warehouse_id_seq', 368, true);


--
-- TOC entry 5349 (class 0 OID 0)
-- Dependencies: 254
-- Name: purchase_detail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('mrp.purchase_detail_id_seq', 1, false);


--
-- TOC entry 5350 (class 0 OID 0)
-- Dependencies: 246
-- Name: purchase_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('mrp.purchase_id_seq', 1, false);


--
-- TOC entry 5351 (class 0 OID 0)
-- Dependencies: 252
-- Name: report_audit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('mrp.report_audit_id_seq', 1, false);


--
-- TOC entry 5352 (class 0 OID 0)
-- Dependencies: 235
-- Name: resource_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('mrp.resource_id_seq', 34, true);


--
-- TOC entry 5353 (class 0 OID 0)
-- Dependencies: 233
-- Name: role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('mrp.role_id_seq', 7, true);


--
-- TOC entry 5354 (class 0 OID 0)
-- Dependencies: 238
-- Name: subresource_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('mrp.subresource_id_seq', 106, true);


--
-- TOC entry 5355 (class 0 OID 0)
-- Dependencies: 221
-- Name: supplier_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('mrp.supplier_id_seq', 13, true);


--
-- TOC entry 5356 (class 0 OID 0)
-- Dependencies: 229
-- Name: supplier_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('mrp.supplier_item_id_seq', 345, true);


--
-- TOC entry 5357 (class 0 OID 0)
-- Dependencies: 250
-- Name: system_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('mrp.system_log_id_seq', 3384, true);


--
-- TOC entry 5358 (class 0 OID 0)
-- Dependencies: 219
-- Name: unit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('mrp.unit_id_seq', 8, true);


--
-- TOC entry 5359 (class 0 OID 0)
-- Dependencies: 231
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('mrp.user_id_seq', 7, true);


--
-- TOC entry 5360 (class 0 OID 0)
-- Dependencies: 225
-- Name: warehouse_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('mrp.warehouse_id_seq', 5, true);


--
-- TOC entry 5361 (class 0 OID 0)
-- Dependencies: 264
-- Name: work_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('mrp.work_order_id_seq', 15, true);


--
-- TOC entry 5042 (class 2606 OID 38834)
-- Name: bom_component bom_component_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.bom_component
    ADD CONSTRAINT bom_component_pkey PRIMARY KEY (id);


--
-- TOC entry 5035 (class 2606 OID 38805)
-- Name: bom bom_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.bom
    ADD CONSTRAINT bom_pkey PRIMARY KEY (id);


--
-- TOC entry 5033 (class 2606 OID 38792)
-- Name: category category_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (categoryid);


--
-- TOC entry 5010 (class 2606 OID 38658)
-- Name: drawer drawer_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.drawer
    ADD CONSTRAINT drawer_pkey PRIMARY KEY (drawerid);


--
-- TOC entry 5003 (class 2606 OID 31017)
-- Name: movement movement_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.movement
    ADD CONSTRAINT movement_pkey PRIMARY KEY (id);


--
-- TOC entry 5029 (class 2606 OID 38775)
-- Name: org_subscription org_subscription_org_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.org_subscription
    ADD CONSTRAINT org_subscription_org_id_key UNIQUE (org_id);


--
-- TOC entry 5031 (class 2606 OID 38773)
-- Name: org_subscription org_subscription_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.org_subscription
    ADD CONSTRAINT org_subscription_pkey PRIMARY KEY (id);


--
-- TOC entry 4956 (class 2606 OID 30719)
-- Name: organization organization_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.organization
    ADD CONSTRAINT organization_code_key UNIQUE (code);


--
-- TOC entry 4958 (class 2606 OID 30717)
-- Name: organization organization_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.organization
    ADD CONSTRAINT organization_pkey PRIMARY KEY (id);


--
-- TOC entry 5014 (class 2606 OID 38705)
-- Name: plan plan_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.plan
    ADD CONSTRAINT plan_code_key UNIQUE (code);


--
-- TOC entry 5016 (class 2606 OID 38703)
-- Name: plan plan_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.plan
    ADD CONSTRAINT plan_pkey PRIMARY KEY (id);


--
-- TOC entry 4964 (class 2606 OID 30780)
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- TOC entry 4972 (class 2606 OID 30833)
-- Name: product_warehouse product_warehouse_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.product_warehouse
    ADD CONSTRAINT product_warehouse_pkey PRIMARY KEY (id);


--
-- TOC entry 5027 (class 2606 OID 38755)
-- Name: purchase_detail purchase_detail_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.purchase_detail
    ADD CONSTRAINT purchase_detail_pkey PRIMARY KEY (id);


--
-- TOC entry 5012 (class 2606 OID 38666)
-- Name: purchase purchase_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.purchase
    ADD CONSTRAINT purchase_pkey PRIMARY KEY (id);


--
-- TOC entry 5025 (class 2606 OID 38736)
-- Name: report_audit report_audit_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.report_audit
    ADD CONSTRAINT report_audit_pkey PRIMARY KEY (id);


--
-- TOC entry 4990 (class 2606 OID 30964)
-- Name: resource resource_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.resource
    ADD CONSTRAINT resource_pkey PRIMARY KEY (id);


--
-- TOC entry 4984 (class 2606 OID 30957)
-- Name: role role_description_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.role
    ADD CONSTRAINT role_description_key UNIQUE (description);


--
-- TOC entry 4986 (class 2606 OID 30955)
-- Name: role role_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.role
    ADD CONSTRAINT role_name_key UNIQUE (name);


--
-- TOC entry 4988 (class 2606 OID 30953)
-- Name: role role_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.role
    ADD CONSTRAINT role_pkey PRIMARY KEY (id);


--
-- TOC entry 5005 (class 2606 OID 31051)
-- Name: role_resource role_resource_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.role_resource
    ADD CONSTRAINT role_resource_pkey PRIMARY KEY (role_id, resource_id, subresource_id);


--
-- TOC entry 4994 (class 2606 OID 30986)
-- Name: subresource subresource_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.subresource
    ADD CONSTRAINT subresource_pkey PRIMARY KEY (id);


--
-- TOC entry 4976 (class 2606 OID 30860)
-- Name: supplier_item supplier_item_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.supplier_item
    ADD CONSTRAINT supplier_item_pkey PRIMARY KEY (id);


--
-- TOC entry 4962 (class 2606 OID 30762)
-- Name: supplier supplier_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.supplier
    ADD CONSTRAINT supplier_pkey PRIMARY KEY (id);


--
-- TOC entry 5021 (class 2606 OID 38714)
-- Name: system_log system_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.system_log
    ADD CONSTRAINT system_log_pkey PRIMARY KEY (id);


--
-- TOC entry 4960 (class 2606 OID 30726)
-- Name: unit unit_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.unit
    ADD CONSTRAINT unit_pkey PRIMARY KEY (id);


--
-- TOC entry 5046 (class 2606 OID 38836)
-- Name: bom_component uq_bom_component; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.bom_component
    ADD CONSTRAINT uq_bom_component UNIQUE (bom_id, component_id);


--
-- TOC entry 5040 (class 2606 OID 38807)
-- Name: bom uq_bom_product_version; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.bom
    ADD CONSTRAINT uq_bom_product_version UNIQUE (org_id, product_id, version);


--
-- TOC entry 4966 (class 2606 OID 30782)
-- Name: product uq_product_org_code; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.product
    ADD CONSTRAINT uq_product_org_code UNIQUE (org_id, code);


--
-- TOC entry 4974 (class 2606 OID 30835)
-- Name: product_warehouse uq_product_warehouse; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.product_warehouse
    ADD CONSTRAINT uq_product_warehouse UNIQUE (productid, warehouseid);


--
-- TOC entry 4978 (class 2606 OID 30862)
-- Name: supplier_item uq_supplier_item_prod_sup; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.supplier_item
    ADD CONSTRAINT uq_supplier_item_prod_sup UNIQUE (product_id, supplier_id);


--
-- TOC entry 5008 (class 2606 OID 31094)
-- Name: user_organization uq_user_org; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.user_organization
    ADD CONSTRAINT uq_user_org PRIMARY KEY (user_id, org_id);


--
-- TOC entry 4980 (class 2606 OID 30945)
-- Name: user user_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp."user"
    ADD CONSTRAINT user_email_key UNIQUE (email);


--
-- TOC entry 4982 (class 2606 OID 30943)
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- TOC entry 4992 (class 2606 OID 30969)
-- Name: user_role user_role_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.user_role
    ADD CONSTRAINT user_role_pkey PRIMARY KEY (role_id, user_id);


--
-- TOC entry 4968 (class 2606 OID 30800)
-- Name: warehouse warehouse_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.warehouse
    ADD CONSTRAINT warehouse_pkey PRIMARY KEY (id);


--
-- TOC entry 5055 (class 2606 OID 38867)
-- Name: work_order work_order_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.work_order
    ADD CONSTRAINT work_order_pkey PRIMARY KEY (id);


--
-- TOC entry 5043 (class 1259 OID 38852)
-- Name: idx_bom_component_bom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_bom_component_bom_id ON mrp.bom_component USING btree (bom_id);


--
-- TOC entry 5044 (class 1259 OID 38853)
-- Name: idx_bom_component_component_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_bom_component_component_id ON mrp.bom_component USING btree (component_id);


--
-- TOC entry 5036 (class 1259 OID 38820)
-- Name: idx_bom_is_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_bom_is_active ON mrp.bom USING btree (is_active);


--
-- TOC entry 5037 (class 1259 OID 38818)
-- Name: idx_bom_org_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_bom_org_id ON mrp.bom USING btree (org_id);


--
-- TOC entry 5038 (class 1259 OID 38819)
-- Name: idx_bom_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_bom_product_id ON mrp.bom USING btree (product_id);


--
-- TOC entry 4995 (class 1259 OID 38907)
-- Name: idx_movement_reference_composite; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_movement_reference_composite ON mrp.movement USING btree (reference_type, reference_id);


--
-- TOC entry 4996 (class 1259 OID 38906)
-- Name: idx_movement_reference_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_movement_reference_id ON mrp.movement USING btree (reference_id);


--
-- TOC entry 4997 (class 1259 OID 38905)
-- Name: idx_movement_reference_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_movement_reference_type ON mrp.movement USING btree (reference_type);


--
-- TOC entry 5047 (class 1259 OID 38903)
-- Name: idx_work_order_assigned_to; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_work_order_assigned_to ON mrp.work_order USING btree (assigned_to);


--
-- TOC entry 5048 (class 1259 OID 38900)
-- Name: idx_work_order_bom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_work_order_bom_id ON mrp.work_order USING btree (bom_id);


--
-- TOC entry 5049 (class 1259 OID 38904)
-- Name: idx_work_order_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_work_order_created_at ON mrp.work_order USING btree (created_at);


--
-- TOC entry 5050 (class 1259 OID 38898)
-- Name: idx_work_order_org_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_work_order_org_id ON mrp.work_order USING btree (org_id);


--
-- TOC entry 5051 (class 1259 OID 38899)
-- Name: idx_work_order_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_work_order_product_id ON mrp.work_order USING btree (product_id);


--
-- TOC entry 5052 (class 1259 OID 38901)
-- Name: idx_work_order_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_work_order_status ON mrp.work_order USING btree (status);


--
-- TOC entry 5053 (class 1259 OID 38902)
-- Name: idx_work_order_warehouse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_work_order_warehouse_id ON mrp.work_order USING btree (warehouse_id);


--
-- TOC entry 4998 (class 1259 OID 31044)
-- Name: ix_movement_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_movement_created_at ON mrp.movement USING btree (created_at);


--
-- TOC entry 4999 (class 1259 OID 31043)
-- Name: ix_movement_from_warehouse; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_movement_from_warehouse ON mrp.movement USING btree (from_warehouse_id);


--
-- TOC entry 5000 (class 1259 OID 31045)
-- Name: ix_movement_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_movement_product_id ON mrp.movement USING btree (product_id);


--
-- TOC entry 5001 (class 1259 OID 31046)
-- Name: ix_movement_to_warehouse; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_movement_to_warehouse ON mrp.movement USING btree (to_warehouse_id);


--
-- TOC entry 4969 (class 1259 OID 30847)
-- Name: ix_product_warehouse_product; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_product_warehouse_product ON mrp.product_warehouse USING btree (productid);


--
-- TOC entry 4970 (class 1259 OID 30846)
-- Name: ix_product_warehouse_warehouse; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_product_warehouse_warehouse ON mrp.product_warehouse USING btree (warehouseid);


--
-- TOC entry 5022 (class 1259 OID 38747)
-- Name: ix_report_audit_org_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_report_audit_org_id ON mrp.report_audit USING btree (org_id);


--
-- TOC entry 5023 (class 1259 OID 38748)
-- Name: ix_report_audit_ts; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_report_audit_ts ON mrp.report_audit USING btree (ts);


--
-- TOC entry 5017 (class 1259 OID 38726)
-- Name: ix_system_log_org_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_system_log_org_id ON mrp.system_log USING btree (org_id);


--
-- TOC entry 5018 (class 1259 OID 38725)
-- Name: ix_system_log_ts; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_system_log_ts ON mrp.system_log USING btree (ts);


--
-- TOC entry 5019 (class 1259 OID 38727)
-- Name: ix_system_log_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_system_log_user_id ON mrp.system_log USING btree (user_id);


--
-- TOC entry 5006 (class 1259 OID 31105)
-- Name: ix_user_org_default; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_user_org_default ON mrp.user_organization USING btree (user_id, is_default);


--
-- TOC entry 5092 (class 2606 OID 38837)
-- Name: bom_component bom_component_bom_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.bom_component
    ADD CONSTRAINT bom_component_bom_id_fkey FOREIGN KEY (bom_id) REFERENCES mrp.bom(id) ON DELETE CASCADE;


--
-- TOC entry 5093 (class 2606 OID 38842)
-- Name: bom_component bom_component_component_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.bom_component
    ADD CONSTRAINT bom_component_component_id_fkey FOREIGN KEY (component_id) REFERENCES mrp.product(id) ON DELETE CASCADE;


--
-- TOC entry 5094 (class 2606 OID 38847)
-- Name: bom_component bom_component_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.bom_component
    ADD CONSTRAINT bom_component_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES mrp.unit(id);


--
-- TOC entry 5090 (class 2606 OID 38808)
-- Name: bom bom_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.bom
    ADD CONSTRAINT bom_org_id_fkey FOREIGN KEY (org_id) REFERENCES mrp.organization(id) ON DELETE CASCADE;


--
-- TOC entry 5091 (class 2606 OID 38813)
-- Name: bom bom_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.bom
    ADD CONSTRAINT bom_product_id_fkey FOREIGN KEY (product_id) REFERENCES mrp.product(id) ON DELETE CASCADE;


--
-- TOC entry 5068 (class 2606 OID 31038)
-- Name: movement movement_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.movement
    ADD CONSTRAINT movement_created_by_fkey FOREIGN KEY (created_by) REFERENCES mrp."user"(id);


--
-- TOC entry 5069 (class 2606 OID 31028)
-- Name: movement movement_from_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.movement
    ADD CONSTRAINT movement_from_warehouse_id_fkey FOREIGN KEY (from_warehouse_id) REFERENCES mrp.warehouse(id);


--
-- TOC entry 5070 (class 2606 OID 31018)
-- Name: movement movement_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.movement
    ADD CONSTRAINT movement_org_id_fkey FOREIGN KEY (org_id) REFERENCES mrp.organization(id);


--
-- TOC entry 5071 (class 2606 OID 31023)
-- Name: movement movement_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.movement
    ADD CONSTRAINT movement_product_id_fkey FOREIGN KEY (product_id) REFERENCES mrp.product(id);


--
-- TOC entry 5072 (class 2606 OID 31033)
-- Name: movement movement_to_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.movement
    ADD CONSTRAINT movement_to_warehouse_id_fkey FOREIGN KEY (to_warehouse_id) REFERENCES mrp.warehouse(id);


--
-- TOC entry 5088 (class 2606 OID 38776)
-- Name: org_subscription org_subscription_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.org_subscription
    ADD CONSTRAINT org_subscription_org_id_fkey FOREIGN KEY (org_id) REFERENCES mrp.organization(id);


--
-- TOC entry 5089 (class 2606 OID 38781)
-- Name: org_subscription org_subscription_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.org_subscription
    ADD CONSTRAINT org_subscription_plan_id_fkey FOREIGN KEY (plan_id) REFERENCES mrp.plan(id);


--
-- TOC entry 5057 (class 2606 OID 30783)
-- Name: product product_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.product
    ADD CONSTRAINT product_org_id_fkey FOREIGN KEY (org_id) REFERENCES mrp.organization(id);


--
-- TOC entry 5058 (class 2606 OID 30788)
-- Name: product product_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.product
    ADD CONSTRAINT product_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES mrp.unit(id);


--
-- TOC entry 5060 (class 2606 OID 30836)
-- Name: product_warehouse product_warehouse_productid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.product_warehouse
    ADD CONSTRAINT product_warehouse_productid_fkey FOREIGN KEY (productid) REFERENCES mrp.product(id);


--
-- TOC entry 5061 (class 2606 OID 30841)
-- Name: product_warehouse product_warehouse_warehouseid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.product_warehouse
    ADD CONSTRAINT product_warehouse_warehouseid_fkey FOREIGN KEY (warehouseid) REFERENCES mrp.warehouse(id);


--
-- TOC entry 5086 (class 2606 OID 38761)
-- Name: purchase_detail purchase_detail_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.purchase_detail
    ADD CONSTRAINT purchase_detail_product_id_fkey FOREIGN KEY (product_id) REFERENCES mrp.product(id);


--
-- TOC entry 5087 (class 2606 OID 38756)
-- Name: purchase_detail purchase_detail_purchase_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.purchase_detail
    ADD CONSTRAINT purchase_detail_purchase_id_fkey FOREIGN KEY (purchase_id) REFERENCES mrp.purchase(id);


--
-- TOC entry 5078 (class 2606 OID 38667)
-- Name: purchase purchase_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.purchase
    ADD CONSTRAINT purchase_org_id_fkey FOREIGN KEY (org_id) REFERENCES mrp.organization(id);


--
-- TOC entry 5079 (class 2606 OID 38677)
-- Name: purchase purchase_supplier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.purchase
    ADD CONSTRAINT purchase_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES mrp.supplier(id);


--
-- TOC entry 5080 (class 2606 OID 38672)
-- Name: purchase purchase_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.purchase
    ADD CONSTRAINT purchase_user_id_fkey FOREIGN KEY (user_id) REFERENCES mrp."user"(id);


--
-- TOC entry 5081 (class 2606 OID 38682)
-- Name: purchase purchase_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.purchase
    ADD CONSTRAINT purchase_warehouse_id_fkey FOREIGN KEY (warehouse_id) REFERENCES mrp.warehouse(id);


--
-- TOC entry 5084 (class 2606 OID 38742)
-- Name: report_audit report_audit_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.report_audit
    ADD CONSTRAINT report_audit_org_id_fkey FOREIGN KEY (org_id) REFERENCES mrp.organization(id);


--
-- TOC entry 5085 (class 2606 OID 38737)
-- Name: report_audit report_audit_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.report_audit
    ADD CONSTRAINT report_audit_user_id_fkey FOREIGN KEY (user_id) REFERENCES mrp."user"(id);


--
-- TOC entry 5073 (class 2606 OID 31057)
-- Name: role_resource role_resource_resource_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.role_resource
    ADD CONSTRAINT role_resource_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES mrp.resource(id);


--
-- TOC entry 5074 (class 2606 OID 31052)
-- Name: role_resource role_resource_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.role_resource
    ADD CONSTRAINT role_resource_role_id_fkey FOREIGN KEY (role_id) REFERENCES mrp.role(id);


--
-- TOC entry 5075 (class 2606 OID 31062)
-- Name: role_resource role_resource_subresource_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.role_resource
    ADD CONSTRAINT role_resource_subresource_id_fkey FOREIGN KEY (subresource_id) REFERENCES mrp.subresource(id);


--
-- TOC entry 5067 (class 2606 OID 30987)
-- Name: subresource subresource_resource_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.subresource
    ADD CONSTRAINT subresource_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES mrp.resource(id);


--
-- TOC entry 5062 (class 2606 OID 30863)
-- Name: supplier_item supplier_item_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.supplier_item
    ADD CONSTRAINT supplier_item_org_id_fkey FOREIGN KEY (org_id) REFERENCES mrp.organization(id);


--
-- TOC entry 5063 (class 2606 OID 30868)
-- Name: supplier_item supplier_item_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.supplier_item
    ADD CONSTRAINT supplier_item_product_id_fkey FOREIGN KEY (product_id) REFERENCES mrp.product(id);


--
-- TOC entry 5064 (class 2606 OID 30873)
-- Name: supplier_item supplier_item_supplier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.supplier_item
    ADD CONSTRAINT supplier_item_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES mrp.supplier(id);


--
-- TOC entry 5056 (class 2606 OID 30763)
-- Name: supplier supplier_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.supplier
    ADD CONSTRAINT supplier_org_id_fkey FOREIGN KEY (org_id) REFERENCES mrp.organization(id);


--
-- TOC entry 5082 (class 2606 OID 38720)
-- Name: system_log system_log_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.system_log
    ADD CONSTRAINT system_log_org_id_fkey FOREIGN KEY (org_id) REFERENCES mrp.organization(id);


--
-- TOC entry 5083 (class 2606 OID 38715)
-- Name: system_log system_log_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.system_log
    ADD CONSTRAINT system_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES mrp."user"(id);


--
-- TOC entry 5076 (class 2606 OID 31100)
-- Name: user_organization user_organization_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.user_organization
    ADD CONSTRAINT user_organization_org_id_fkey FOREIGN KEY (org_id) REFERENCES mrp.organization(id);


--
-- TOC entry 5077 (class 2606 OID 31095)
-- Name: user_organization user_organization_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.user_organization
    ADD CONSTRAINT user_organization_user_id_fkey FOREIGN KEY (user_id) REFERENCES mrp."user"(id);


--
-- TOC entry 5065 (class 2606 OID 30970)
-- Name: user_role user_role_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.user_role
    ADD CONSTRAINT user_role_role_id_fkey FOREIGN KEY (role_id) REFERENCES mrp.role(id);


--
-- TOC entry 5066 (class 2606 OID 30975)
-- Name: user_role user_role_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.user_role
    ADD CONSTRAINT user_role_user_id_fkey FOREIGN KEY (user_id) REFERENCES mrp."user"(id);


--
-- TOC entry 5059 (class 2606 OID 30801)
-- Name: warehouse warehouse_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.warehouse
    ADD CONSTRAINT warehouse_org_id_fkey FOREIGN KEY (org_id) REFERENCES mrp.organization(id);


--
-- TOC entry 5095 (class 2606 OID 38888)
-- Name: work_order work_order_assigned_to_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.work_order
    ADD CONSTRAINT work_order_assigned_to_fkey FOREIGN KEY (assigned_to) REFERENCES mrp."user"(id);


--
-- TOC entry 5096 (class 2606 OID 38878)
-- Name: work_order work_order_bom_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.work_order
    ADD CONSTRAINT work_order_bom_id_fkey FOREIGN KEY (bom_id) REFERENCES mrp.bom(id) ON DELETE RESTRICT;


--
-- TOC entry 5097 (class 2606 OID 38893)
-- Name: work_order work_order_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.work_order
    ADD CONSTRAINT work_order_created_by_fkey FOREIGN KEY (created_by) REFERENCES mrp."user"(id);


--
-- TOC entry 5098 (class 2606 OID 38868)
-- Name: work_order work_order_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.work_order
    ADD CONSTRAINT work_order_org_id_fkey FOREIGN KEY (org_id) REFERENCES mrp.organization(id) ON DELETE CASCADE;


--
-- TOC entry 5099 (class 2606 OID 38873)
-- Name: work_order work_order_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.work_order
    ADD CONSTRAINT work_order_product_id_fkey FOREIGN KEY (product_id) REFERENCES mrp.product(id) ON DELETE CASCADE;


--
-- TOC entry 5100 (class 2606 OID 38883)
-- Name: work_order work_order_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE IF EXISTS mrp.work_order
    ADD CONSTRAINT work_order_warehouse_id_fkey FOREIGN KEY (warehouse_id) REFERENCES mrp.warehouse(id);


-- Completed on 2025-11-08 16:51:02

--
-- PostgreSQL database dump complete
--

\unrestrict 8HW0MHddggHkuQO8UF5K7NrWIMY21ogMkB5nBQNLHT0VhALG9dhUAgHnskE6eAx


