--
-- PostgreSQL database dump
--

\restrict bJ2frhPsISr8N68bi9fajnmeqUZLP7P7FK3XtDj8zcs0dWjDfMS8S72D5Pa00dx

-- Dumped from database version 17.6
-- Dumped by pg_dump version 18.3

-- Started on 2026-06-15 13:17:15

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 26 (class 2615 OID 16498)
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- TOC entry 14 (class 2615 OID 16392)
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- TOC entry 24 (class 2615 OID 16578)
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO supabase_admin;

--
-- TOC entry 23 (class 2615 OID 16567)
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- TOC entry 11 (class 2615 OID 16390)
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- TOC entry 12 (class 2615 OID 16559)
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- TOC entry 27 (class 2615 OID 16546)
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- TOC entry 21 (class 2615 OID 16607)
-- Name: vault; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA vault;


ALTER SCHEMA vault OWNER TO supabase_admin;

--
-- TOC entry 2 (class 3079 OID 16393)
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- TOC entry 4487 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- TOC entry 4 (class 3079 OID 16447)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- TOC entry 4488 (class 0 OID 0)
-- Dependencies: 4
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- TOC entry 5 (class 3079 OID 16608)
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- TOC entry 4489 (class 0 OID 0)
-- Dependencies: 5
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- TOC entry 3 (class 3079 OID 16436)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- TOC entry 4490 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 1153 (class 1247 OID 16744)
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- TOC entry 1177 (class 1247 OID 16885)
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


ALTER TYPE auth.code_challenge_method OWNER TO supabase_auth_admin;

--
-- TOC entry 1150 (class 1247 OID 16738)
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- TOC entry 1147 (class 1247 OID 16732)
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- TOC entry 1195 (class 1247 OID 16988)
-- Name: oauth_authorization_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_authorization_status AS ENUM (
    'pending',
    'approved',
    'denied',
    'expired'
);


ALTER TYPE auth.oauth_authorization_status OWNER TO supabase_auth_admin;

--
-- TOC entry 1207 (class 1247 OID 17061)
-- Name: oauth_client_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_client_type AS ENUM (
    'public',
    'confidential'
);


ALTER TYPE auth.oauth_client_type OWNER TO supabase_auth_admin;

--
-- TOC entry 1189 (class 1247 OID 16966)
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


ALTER TYPE auth.oauth_registration_type OWNER TO supabase_auth_admin;

--
-- TOC entry 1198 (class 1247 OID 16998)
-- Name: oauth_response_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_response_type AS ENUM (
    'code'
);


ALTER TYPE auth.oauth_response_type OWNER TO supabase_auth_admin;

--
-- TOC entry 1183 (class 1247 OID 16927)
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


ALTER TYPE auth.one_time_token_type OWNER TO supabase_auth_admin;

--
-- TOC entry 1261 (class 1247 OID 17406)
-- Name: action; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


ALTER TYPE realtime.action OWNER TO supabase_admin;

--
-- TOC entry 1252 (class 1247 OID 17367)
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


ALTER TYPE realtime.equality_op OWNER TO supabase_admin;

--
-- TOC entry 1255 (class 1247 OID 17381)
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


ALTER TYPE realtime.user_defined_filter OWNER TO supabase_admin;

--
-- TOC entry 1267 (class 1247 OID 17448)
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


ALTER TYPE realtime.wal_column OWNER TO supabase_admin;

--
-- TOC entry 1264 (class 1247 OID 17419)
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


ALTER TYPE realtime.wal_rls OWNER TO supabase_admin;

--
-- TOC entry 1240 (class 1247 OID 17297)
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS',
    'VECTOR'
);


ALTER TYPE storage.buckettype OWNER TO supabase_storage_admin;

--
-- TOC entry 456 (class 1255 OID 16544)
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- TOC entry 4491 (class 0 OID 0)
-- Dependencies: 456
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- TOC entry 469 (class 1255 OID 16714)
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- TOC entry 455 (class 1255 OID 16543)
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- TOC entry 4494 (class 0 OID 0)
-- Dependencies: 455
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- TOC entry 454 (class 1255 OID 16542)
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- TOC entry 4496 (class 0 OID 0)
-- Dependencies: 454
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- TOC entry 457 (class 1255 OID 16551)
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO supabase_admin;

--
-- TOC entry 4512 (class 0 OID 0)
-- Dependencies: 457
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- TOC entry 461 (class 1255 OID 16572)
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
begin
    if not exists (
        select 1
        from pg_event_trigger_ddl_commands() ev
        join pg_catalog.pg_extension e on ev.objid = e.oid
        where e.extname = 'pg_graphql'
    ) then
        return;
    end if;

    drop function if exists graphql_public.graphql;
    create or replace function graphql_public.graphql(
        "operationName" text default null,
        query text default null,
        variables jsonb default null,
        extensions jsonb default null
    )
        returns jsonb
        language sql
    as $$
        select graphql.resolve(
            query := query,
            variables := coalesce(variables, '{}'),
            "operationName" := "operationName",
            extensions := extensions
        );
    $$;

    -- Attach the wrapper to the extension so DROP EXTENSION cascades to it,
    -- which in turn triggers set_graphql_placeholder to reinstall the "not enabled" stub.
    alter extension pg_graphql add function graphql_public.graphql(text, text, jsonb, jsonb);

    grant usage on schema graphql to postgres, anon, authenticated, service_role;
    grant execute on function graphql.resolve to postgres, anon, authenticated, service_role;
    grant usage on schema graphql to postgres with grant option;
    grant usage on schema graphql_public to postgres with grant option;
end;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- TOC entry 4514 (class 0 OID 0)
-- Dependencies: 461
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- TOC entry 458 (class 1255 OID 16553)
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    IF EXISTS (
      SELECT FROM pg_extension
      WHERE extname = 'pg_net'
      -- all versions in use on existing projects as of 2025-02-20
      -- version 0.12.0 onwards don't need these applied
      AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8', '0.10.0', '0.11.0')
    ) THEN
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO supabase_admin;

--
-- TOC entry 4516 (class 0 OID 0)
-- Dependencies: 458
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- TOC entry 459 (class 1255 OID 16563)
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- TOC entry 460 (class 1255 OID 16564)
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- TOC entry 462 (class 1255 OID 16574)
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- TOC entry 4545 (class 0 OID 0)
-- Dependencies: 462
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- TOC entry 468 (class 1255 OID 16665)
-- Name: graphql(text, text, jsonb, jsonb); Type: FUNCTION; Schema: graphql_public; Owner: supabase_admin
--

CREATE FUNCTION graphql_public.graphql("operationName" text DEFAULT NULL::text, query text DEFAULT NULL::text, variables jsonb DEFAULT NULL::jsonb, extensions jsonb DEFAULT NULL::jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;


ALTER FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) OWNER TO supabase_admin;

--
-- TOC entry 404 (class 1255 OID 16391)
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: supabase_admin
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $_$
  BEGIN
      RAISE DEBUG 'PgBouncer auth request: %', p_usename;

      RETURN QUERY
      SELECT
          rolname::text,
          CASE WHEN rolvaliduntil < now()
              THEN null
              ELSE rolpassword::text
          END
      FROM pg_authid
      WHERE rolname=$1 and rolcanlogin;
  END;
  $_$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO supabase_admin;

--
-- TOC entry 492 (class 1255 OID 17441)
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
    -- Regclass of the table e.g. public.notes
    entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

    -- I, U, D, T: insert, update ...
    action realtime.action = (
        case wal ->> 'action'
            when 'I' then 'INSERT'
            when 'U' then 'UPDATE'
            when 'D' then 'DELETE'
            else 'ERROR'
        end
    );

    -- Is row level security enabled for the table
    is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

    subscriptions realtime.subscription[] = array_agg(subs)
        from
            realtime.subscription subs
        where
            subs.entity = entity_
            -- Filter by action early - only get subscriptions interested in this action
            -- action_filter column can be: '*' (all), 'INSERT', 'UPDATE', or 'DELETE'
            and (subs.action_filter = '*' or subs.action_filter = action::text);

    -- Subscription vars
    working_role regrole;
    working_selected_columns text[];
    claimed_role regrole;
    claims jsonb;

    subscription_id uuid;
    subscription_has_access bool;
    visible_to_subscription_ids uuid[] = '{}';

    -- structured info for wal's columns
    columns realtime.wal_column[];
    -- previous identity values for update/delete
    old_columns realtime.wal_column[];

    error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

    -- Primary jsonb output for record
    output jsonb;

    -- Loop record for iterating unique roles (outer loop)
    role_record record;
    -- Loop record for iterating unique selected_columns within a role (inner loop)
    cols_record record;
    -- Subscription ids visible at the role level (before fanning out by selected_columns)
    visible_role_sub_ids uuid[] = '{}';

begin
    perform set_config('role', null, true);

    columns =
        array_agg(
            (
                x->>'name',
                x->>'type',
                x->>'typeoid',
                realtime.cast(
                    (x->'value') #>> '{}',
                    coalesce(
                        (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                        (x->>'type')::regtype
                    )
                ),
                (pks ->> 'name') is not null,
                true
            )::realtime.wal_column
        )
        from
            jsonb_array_elements(wal -> 'columns') x
            left join jsonb_array_elements(wal -> 'pk') pks
                on (x ->> 'name') = (pks ->> 'name');

    old_columns =
        array_agg(
            (
                x->>'name',
                x->>'type',
                x->>'typeoid',
                realtime.cast(
                    (x->'value') #>> '{}',
                    coalesce(
                        (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                        (x->>'type')::regtype
                    )
                ),
                (pks ->> 'name') is not null,
                true
            )::realtime.wal_column
        )
        from
            jsonb_array_elements(wal -> 'identity') x
            left join jsonb_array_elements(wal -> 'pk') pks
                on (x ->> 'name') = (pks ->> 'name');

    for role_record in
        select claims_role
        from (select distinct claims_role from unnest(subscriptions)) t
        order by claims_role::text
    loop
        working_role := role_record.claims_role;

        -- Update `is_selectable` for columns and old_columns (once per role)
        columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(columns) c;

        old_columns =
                array_agg(
                    (
                        c.name,
                        c.type_name,
                        c.type_oid,
                        c.value,
                        c.is_pkey,
                        pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                    )::realtime.wal_column
                )
                from
                    unnest(old_columns) c;

        if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
            -- Fan out 400 error per distinct selected_columns for this role
            for cols_record in
                select selected_columns
                from (select distinct selected_columns from unnest(subscriptions) s where s.claims_role = working_role) t
                order by coalesce(array_to_string(selected_columns, ','), '')
            loop
                working_selected_columns := cols_record.selected_columns;
                return next (
                    jsonb_build_object(
                        'schema', wal ->> 'schema',
                        'table', wal ->> 'table',
                        'type', action
                    ),
                    is_rls_enabled,
                    (select array_agg(s.subscription_id) from unnest(subscriptions) as s where s.claims_role = working_role and (s.selected_columns is not distinct from working_selected_columns)),
                    array['Error 400: Bad Request, no primary key']
                )::realtime.wal_rls;
            end loop;

        -- The claims role does not have SELECT permission to the primary key of entity
        elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
            -- Fan out 401 error per distinct selected_columns for this role
            for cols_record in
                select selected_columns
                from (select distinct selected_columns from unnest(subscriptions) s where s.claims_role = working_role) t
                order by coalesce(array_to_string(selected_columns, ','), '')
            loop
                working_selected_columns := cols_record.selected_columns;
                return next (
                    jsonb_build_object(
                        'schema', wal ->> 'schema',
                        'table', wal ->> 'table',
                        'type', action
                    ),
                    is_rls_enabled,
                    (select array_agg(s.subscription_id) from unnest(subscriptions) as s where s.claims_role = working_role and (s.selected_columns is not distinct from working_selected_columns)),
                    array['Error 401: Unauthorized']
                )::realtime.wal_rls;
            end loop;

        else
            -- Create the prepared statement (once per role)
            if is_rls_enabled and action <> 'DELETE' then
                if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                    deallocate walrus_rls_stmt;
                end if;
                execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
            end if;

            -- Collect all visible subscription IDs for this role (filter check + RLS check)
            visible_role_sub_ids = '{}';

            for subscription_id, claims in (
                    select
                        subs.subscription_id,
                        subs.claims
                    from
                        unnest(subscriptions) subs
                    where
                        subs.entity = entity_
                        and subs.claims_role = working_role
                        and (
                            realtime.is_visible_through_filters(columns, subs.filters)
                            or (
                              action = 'DELETE'
                              and realtime.is_visible_through_filters(old_columns, subs.filters)
                            )
                        )
            ) loop

                if not is_rls_enabled or action = 'DELETE' then
                    visible_role_sub_ids = visible_role_sub_ids || subscription_id;
                else
                    -- Check if RLS allows the role to see the record
                    perform
                        -- Trim leading and trailing quotes from working_role because set_config
                        -- doesn't recognize the role as valid if they are included
                        set_config('role', trim(both '"' from working_role::text), true),
                        set_config('request.jwt.claims', claims::text, true);

                    execute 'execute walrus_rls_stmt' into subscription_has_access;

                    if subscription_has_access then
                        visible_role_sub_ids = visible_role_sub_ids || subscription_id;
                    end if;
                end if;
            end loop;

            perform set_config('role', null, true);

            -- Inner loop: per distinct selected_columns for this role
            for cols_record in
                select selected_columns
                from (select distinct selected_columns from unnest(subscriptions) s where s.claims_role = working_role) t
                order by coalesce(array_to_string(selected_columns, ','), '')
            loop
                working_selected_columns := cols_record.selected_columns;

                output = jsonb_build_object(
                    'schema', wal ->> 'schema',
                    'table', wal ->> 'table',
                    'type', action,
                    'commit_timestamp', to_char(
                        ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                        'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
                    ),
                    'columns', (
                        select
                            jsonb_agg(
                                jsonb_build_object(
                                    'name', pa.attname,
                                    'type', pt.typname
                                )
                                order by pa.attnum asc
                            )
                        from
                            pg_attribute pa
                            join pg_type pt
                                on pa.atttypid = pt.oid
                            left join (
                                select unnest(conkey) as pkey_attnum
                                from pg_constraint
                                where conrelid = entity_ and contype = 'p'
                            ) pk on pk.pkey_attnum = pa.attnum
                        where
                            attrelid = entity_
                            and attnum > 0
                            and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
                            and (working_selected_columns is null or pa.attname = any(working_selected_columns) or pk.pkey_attnum is not null)
                    )
                )
                -- Add "record" key for insert and update
                || case
                    when action in ('INSERT', 'UPDATE') then
                        jsonb_build_object(
                            'record',
                            (
                                select
                                    jsonb_object_agg(
                                        -- if unchanged toast, get column name and value from old record
                                        coalesce((c).name, (oc).name),
                                        case
                                            when (c).name is null then (oc).value
                                            else (c).value
                                        end
                                    )
                                from
                                    unnest(columns) c
                                    full outer join unnest(old_columns) oc
                                        on (c).name = (oc).name
                                where
                                    coalesce((c).is_selectable, (oc).is_selectable)
                                    and (working_selected_columns is null or coalesce((c).name, (oc).name) = any(working_selected_columns) or coalesce((c).is_pkey, (oc).is_pkey))
                                    and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            )
                        )
                    else '{}'::jsonb
                end
                -- Add "old_record" key for update and delete
                || case
                    when action = 'UPDATE' then
                        jsonb_build_object(
                                'old_record',
                                (
                                    select jsonb_object_agg((c).name, (c).value)
                                    from unnest(old_columns) c
                                    where
                                        (c).is_selectable
                                        and (working_selected_columns is null or (c).name = any(working_selected_columns) or (c).is_pkey)
                                        and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                                )
                            )
                    when action = 'DELETE' then
                        jsonb_build_object(
                            'old_record',
                            (
                                select jsonb_object_agg((c).name, (c).value)
                                from unnest(old_columns) c
                                where
                                    (c).is_selectable
                                    and (working_selected_columns is null or (c).name = any(working_selected_columns) or (c).is_pkey)
                                    and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                                    and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                            )
                        )
                    else '{}'::jsonb
                end;

                -- Filter visible_role_sub_ids to those matching the current selected_columns group
                visible_to_subscription_ids = coalesce(
                    (
                        select array_agg(s.subscription_id)
                        from unnest(subscriptions) s
                        where s.claims_role = working_role
                          and (s.selected_columns is not distinct from working_selected_columns)
                          and s.subscription_id = any(visible_role_sub_ids)
                    ),
                    '{}'::uuid[]
                );

                return next (
                    output,
                    is_rls_enabled,
                    visible_to_subscription_ids,
                    case
                        when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                        else '{}'
                    end
                )::realtime.wal_rls;
            end loop;

        end if;
    end loop;

    perform set_config('role', null, true);
end;
$$;


ALTER FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) OWNER TO supabase_admin;

--
-- TOC entry 497 (class 1255 OID 17520)
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


ALTER FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) OWNER TO supabase_admin;

--
-- TOC entry 494 (class 1255 OID 17453)
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


ALTER FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) OWNER TO supabase_admin;

--
-- TOC entry 490 (class 1255 OID 17403)
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
declare
  res jsonb;
begin
  if type_::text = 'bytea' then
    return to_jsonb(val);
  end if;
  execute format('select to_jsonb(%L::'|| type_::text || ')', val) into res;
  return res;
end
$$;


ALTER FUNCTION realtime."cast"(val text, type_ regtype) OWNER TO supabase_admin;

--
-- TOC entry 489 (class 1255 OID 17398)
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) OWNER TO supabase_admin;

--
-- TOC entry 493 (class 1255 OID 17449)
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


ALTER FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) OWNER TO supabase_admin;

--
-- TOC entry 499 (class 1255 OID 25378)
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS TABLE(wal jsonb, is_rls_enabled boolean, subscription_ids uuid[], errors text[], slot_changes_count bigint)
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
  WITH pub AS (
    SELECT
      concat_ws(
        ',',
        CASE WHEN bool_or(pubinsert) THEN 'insert' ELSE NULL END,
        CASE WHEN bool_or(pubupdate) THEN 'update' ELSE NULL END,
        CASE WHEN bool_or(pubdelete) THEN 'delete' ELSE NULL END
      ) AS w2j_actions,
      coalesce(
        string_agg(
          realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
          ','
        ) filter (WHERE ppt.tablename IS NOT NULL),
        ''
      ) AS w2j_add_tables
    FROM pg_publication pp
    LEFT JOIN pg_publication_tables ppt ON pp.pubname = ppt.pubname
    WHERE pp.pubname = publication
    GROUP BY pp.pubname
    LIMIT 1
  ),
  -- MATERIALIZED ensures pg_logical_slot_get_changes is called exactly once
  w2j AS MATERIALIZED (
    SELECT x.*, pub.w2j_add_tables
    FROM pub,
         pg_logical_slot_get_changes(
           slot_name, null, max_changes,
           'include-pk', 'true',
           'include-transaction', 'false',
           'include-timestamp', 'true',
           'include-type-oids', 'true',
           'format-version', '2',
           'actions', pub.w2j_actions,
           'add-tables', pub.w2j_add_tables
         ) x
  ),
  slot_count AS (
    SELECT count(*)::bigint AS cnt
    FROM w2j
    WHERE w2j.w2j_add_tables <> ''
  ),
  rls_filtered AS (
    SELECT xyz.wal, xyz.is_rls_enabled, xyz.subscription_ids, xyz.errors
    FROM w2j,
         realtime.apply_rls(
           wal := w2j.data::jsonb,
           max_record_bytes := max_record_bytes
         ) xyz(wal, is_rls_enabled, subscription_ids, errors)
    WHERE w2j.w2j_add_tables <> ''
      AND xyz.subscription_ids[1] IS NOT NULL
  )
  SELECT rf.wal, rf.is_rls_enabled, rf.subscription_ids, rf.errors, sc.cnt
  FROM rls_filtered rf, slot_count sc

  UNION ALL

  SELECT null, null, null, null, sc.cnt
  FROM slot_count sc
  WHERE NOT EXISTS (SELECT 1 FROM rls_filtered)
$$;


ALTER FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) OWNER TO supabase_admin;

--
-- TOC entry 488 (class 1255 OID 17397)
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
  SELECT
    realtime.wal2json_escape_identifier(nsp.nspname::text)
    || '.'
    || realtime.wal2json_escape_identifier(pc.relname::text)
  FROM pg_class pc
  JOIN pg_namespace nsp ON pc.relnamespace = nsp.oid
  WHERE pc.oid = entity
$$;


ALTER FUNCTION realtime.quote_wal2json(entity regclass) OWNER TO supabase_admin;

--
-- TOC entry 496 (class 1255 OID 17519)
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
  final_payload jsonb;
BEGIN
  BEGIN
    -- Generate a new UUID for the id
    generated_id := gen_random_uuid();

    -- Check if payload has an 'id' key, if not, add the generated UUID
    IF payload ? 'id' THEN
      final_payload := payload;
    ELSE
      final_payload := jsonb_set(payload, '{id}', to_jsonb(generated_id));
    END IF;

    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (id, payload, event, topic, private, extension)
    VALUES (generated_id, final_payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      RAISE WARNING 'ErrorSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


ALTER FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) OWNER TO supabase_admin;

--
-- TOC entry 500 (class 1255 OID 25379)
-- Name: send_binary(bytea, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.send_binary(payload bytea, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
BEGIN
  BEGIN
    generated_id := gen_random_uuid();

    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    INSERT INTO realtime.messages (id, binary_payload, event, topic, private, extension)
    VALUES (generated_id, payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'ErrorSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


ALTER FUNCTION realtime.send_binary(payload bytea, event text, topic text, private boolean) OWNER TO supabase_admin;

--
-- TOC entry 487 (class 1255 OID 17395)
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
    col_names text[] = coalesce(
            array_agg(c.column_name order by c.ordinal_position),
            '{}'::text[]
        )
        from
            information_schema.columns c
        where
            format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
            and pg_catalog.has_column_privilege(
                (new.claims ->> 'role'),
                format('%I.%I', c.table_schema, c.table_name)::regclass,
                c.column_name,
                'SELECT'
            );
    table_col_names text[] = coalesce(
            array_agg(pa.attname),
            '{}'::text[]
        )
        from
            pg_attribute pa
        where
            pa.attrelid = new.entity
            and pa.attnum > 0;
    filter realtime.user_defined_filter;
    col_type regtype;
    in_val jsonb;
    selected_col text;
begin
    for filter in select * from unnest(new.filters) loop
        -- Filtered column is valid
        if not filter.column_name = any(col_names) then
            raise exception 'invalid column for filter %', filter.column_name;
        end if;

        -- Type is sanitized and safe for string interpolation
        col_type = (
            select atttypid::regtype
            from pg_catalog.pg_attribute
            where attrelid = new.entity
                  and attname = filter.column_name
        );
        if col_type is null then
            raise exception 'failed to lookup type for column %', filter.column_name;
        end if;
        if filter.op = 'in'::realtime.equality_op then
            in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
            if coalesce(jsonb_array_length(in_val), 0) > 100 then
                raise exception 'too many values for `in` filter. Maximum 100';
            end if;
        else
            -- raises an exception if value is not coercable to type
            perform realtime.cast(filter.value, col_type);
        end if;
    end loop;

    -- Validate that selected_columns reference columns the role can SELECT
    if new.selected_columns is not null then
        for selected_col in select * from unnest(new.selected_columns) loop
            if not selected_col = any(col_names) then
                raise exception 'invalid column for select %', selected_col;
            end if;
        end loop;
    end if;

    -- Apply consistent order to filters so the unique constraint on
    -- (subscription_id, entity, filters) can't be tricked by a different filter order
    new.filters = coalesce(
        array_agg(f order by f.column_name, f.op, f.value),
        '{}'
    ) from unnest(new.filters) f;

    -- Normalize selected_columns order so ARRAY['a','b'] and ARRAY['b','a'] are
    -- treated as the same subscription group in apply_rls
    new.selected_columns = (
        select array_agg(c order by c)
        from unnest(new.selected_columns) c
    );

    return new;
end;
$$;


ALTER FUNCTION realtime.subscription_check_filters() OWNER TO supabase_admin;

--
-- TOC entry 491 (class 1255 OID 17430)
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


ALTER FUNCTION realtime.to_regrole(role_name text) OWNER TO supabase_admin;

--
-- TOC entry 495 (class 1255 OID 17513)
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


ALTER FUNCTION realtime.topic() OWNER TO supabase_realtime_admin;

--
-- TOC entry 498 (class 1255 OID 25377)
-- Name: wal2json_escape_identifier(text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.wal2json_escape_identifier(name text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
  -- Prefix `\`, `,`, `.`, and any whitespace with `\`
  SELECT regexp_replace(name, '([\\,.[:space:]])', '\\\1', 'g')
$$;


ALTER FUNCTION realtime.wal2json_escape_identifier(name text) OWNER TO supabase_admin;

--
-- TOC entry 486 (class 1255 OID 17362)
-- Name: allow_any_operation(text[]); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.allow_any_operation(expected_operations text[]) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  WITH current_operation AS (
    SELECT storage.operation() AS raw_operation
  ),
  normalized AS (
    SELECT CASE
      WHEN raw_operation LIKE 'storage.%' THEN substr(raw_operation, 9)
      ELSE raw_operation
    END AS current_operation
    FROM current_operation
  )
  SELECT EXISTS (
    SELECT 1
    FROM normalized n
    CROSS JOIN LATERAL unnest(expected_operations) AS expected_operation
    WHERE expected_operation IS NOT NULL
      AND expected_operation <> ''
      AND n.current_operation = CASE
        WHEN expected_operation LIKE 'storage.%' THEN substr(expected_operation, 9)
        ELSE expected_operation
      END
  );
$$;


ALTER FUNCTION storage.allow_any_operation(expected_operations text[]) OWNER TO supabase_storage_admin;

--
-- TOC entry 485 (class 1255 OID 17361)
-- Name: allow_only_operation(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.allow_only_operation(expected_operation text) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  WITH current_operation AS (
    SELECT storage.operation() AS raw_operation
  ),
  normalized AS (
    SELECT
      CASE
        WHEN raw_operation LIKE 'storage.%' THEN substr(raw_operation, 9)
        ELSE raw_operation
      END AS current_operation,
      CASE
        WHEN expected_operation LIKE 'storage.%' THEN substr(expected_operation, 9)
        ELSE expected_operation
      END AS requested_operation
    FROM current_operation
  )
  SELECT CASE
    WHEN requested_operation IS NULL OR requested_operation = '' THEN FALSE
    ELSE COALESCE(current_operation = requested_operation, FALSE)
  END
  FROM normalized;
$$;


ALTER FUNCTION storage.allow_only_operation(expected_operation text) OWNER TO supabase_storage_admin;

--
-- TOC entry 476 (class 1255 OID 17238)
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


ALTER FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) OWNER TO supabase_storage_admin;

--
-- TOC entry 479 (class 1255 OID 17294)
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.enforce_bucket_name_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if length(new.name) > 100 then
        raise exception 'bucket name "%" is too long (% characters). Max is 100.', new.name, length(new.name);
    end if;
    return new;
end;
$$;


ALTER FUNCTION storage.enforce_bucket_name_length() OWNER TO supabase_storage_admin;

--
-- TOC entry 472 (class 1255 OID 17213)
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
    _filename text;
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Get the last path segment (the actual filename)
    SELECT _parts[array_length(_parts, 1)] INTO _filename;
    -- Extract extension: reverse, split on '.', then reverse again
    RETURN reverse(split_part(reverse(_filename), '.', 1));
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- TOC entry 471 (class 1255 OID 17212)
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- TOC entry 470 (class 1255 OID 17211)
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Return everything except the last segment
    RETURN _parts[1 : array_length(_parts,1) - 1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- TOC entry 480 (class 1255 OID 17350)
-- Name: get_common_prefix(text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT CASE
    WHEN position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)) > 0
    THEN left(p_key, length(p_prefix) + position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)))
    ELSE NULL
END;
$$;


ALTER FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) OWNER TO supabase_storage_admin;

--
-- TOC entry 473 (class 1255 OID 17225)
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::bigint)::bigint as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- TOC entry 477 (class 1255 OID 17277)
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


ALTER FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text) OWNER TO supabase_storage_admin;

--
-- TOC entry 481 (class 1255 OID 17351)
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;

    -- Configuration
    v_is_asc BOOLEAN;
    v_prefix TEXT;
    v_start TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_is_asc := lower(coalesce(sort_order, 'asc')) = 'asc';
    v_prefix := coalesce(prefix_param, '');
    v_start := CASE WHEN coalesce(next_token, '') <> '' THEN next_token ELSE coalesce(start_after, '') END;
    v_file_batch_size := LEAST(GREATEST(max_keys * 2, 100), 1000);

    -- Calculate upper bound for prefix filtering (bytewise, using COLLATE "C")
    IF v_prefix = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix, 1) = delimiter_param THEN
        v_upper_bound := left(v_prefix, -1) || chr(ascii(delimiter_param) + 1);
    ELSE
        v_upper_bound := left(v_prefix, -1) || chr(ascii(right(v_prefix, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'AND o.name COLLATE "C" < $3 ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'AND o.name COLLATE "C" >= $3 ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- ========================================================================
    -- SEEK INITIALIZATION: Determine starting position
    -- ========================================================================
    IF v_start = '' THEN
        IF v_is_asc THEN
            v_next_seek := v_prefix;
        ELSE
            -- DESC without cursor: find the last item in range
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;

            IF v_next_seek IS NOT NULL THEN
                v_next_seek := v_next_seek || delimiter_param;
            ELSE
                RETURN;
            END IF;
        END IF;
    ELSE
        -- Cursor provided: determine if it refers to a folder or leaf
        IF EXISTS (
            SELECT 1 FROM storage.objects o
            WHERE o.bucket_id = _bucket_id
              AND o.name COLLATE "C" LIKE v_start || delimiter_param || '%'
            LIMIT 1
        ) THEN
            -- Cursor refers to a folder
            IF v_is_asc THEN
                v_next_seek := v_start || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_start || delimiter_param;
            END IF;
        ELSE
            -- Cursor refers to a leaf object
            IF v_is_asc THEN
                v_next_seek := v_start || delimiter_param;
            ELSE
                v_next_seek := v_start;
            END IF;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= max_keys;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(v_peek_name, v_prefix, delimiter_param);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Emit and skip to next folder (no heap access needed)
            name := rtrim(v_common_prefix, delimiter_param);
            id := NULL;
            updated_at := NULL;
            created_at := NULL;
            last_accessed_at := NULL;
            metadata := NULL;
            RETURN NEXT;
            v_count := v_count + 1;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := left(v_common_prefix, -1) || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_common_prefix;
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query USING _bucket_id, v_next_seek,
                CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix) ELSE v_prefix END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(v_current.name, v_prefix, delimiter_param);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := v_current.name;
                    EXIT;
                END IF;

                -- Emit file
                name := v_current.name;
                id := v_current.id;
                updated_at := v_current.updated_at;
                created_at := v_current.created_at;
                last_accessed_at := v_current.last_accessed_at;
                metadata := v_current.metadata;
                RETURN NEXT;
                v_count := v_count + 1;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := v_current.name || delimiter_param;
                ELSE
                    v_next_seek := v_current.name;
                END IF;

                EXIT WHEN v_count >= max_keys;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


ALTER FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text, sort_order text) OWNER TO supabase_storage_admin;

--
-- TOC entry 478 (class 1255 OID 17293)
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


ALTER FUNCTION storage.operation() OWNER TO supabase_storage_admin;

--
-- TOC entry 484 (class 1255 OID 17357)
-- Name: protect_delete(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.protect_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Check if storage.allow_delete_query is set to 'true'
    IF COALESCE(current_setting('storage.allow_delete_query', true), 'false') != 'true' THEN
        RAISE EXCEPTION 'Direct deletion from storage tables is not allowed. Use the Storage API instead.'
            USING HINT = 'This prevents accidental data loss from orphaned objects.',
                  ERRCODE = '42501';
    END IF;
    RETURN NULL;
END;
$$;


ALTER FUNCTION storage.protect_delete() OWNER TO supabase_storage_admin;

--
-- TOC entry 474 (class 1255 OID 17227)
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;
    v_delimiter CONSTANT TEXT := '/';

    -- Configuration
    v_limit INT;
    v_prefix TEXT;
    v_prefix_lower TEXT;
    v_is_asc BOOLEAN;
    v_order_by TEXT;
    v_sort_order TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;
    v_skipped INT := 0;
BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_limit := LEAST(coalesce(limits, 100), 1500);
    v_prefix := coalesce(prefix, '') || coalesce(search, '');
    v_prefix_lower := lower(v_prefix);
    v_is_asc := lower(coalesce(sortorder, 'asc')) = 'asc';
    v_file_batch_size := LEAST(GREATEST(v_limit * 2, 100), 1000);

    -- Validate sort column
    CASE lower(coalesce(sortcolumn, 'name'))
        WHEN 'name' THEN v_order_by := 'name';
        WHEN 'updated_at' THEN v_order_by := 'updated_at';
        WHEN 'created_at' THEN v_order_by := 'created_at';
        WHEN 'last_accessed_at' THEN v_order_by := 'last_accessed_at';
        ELSE v_order_by := 'name';
    END CASE;

    v_sort_order := CASE WHEN v_is_asc THEN 'asc' ELSE 'desc' END;

    -- ========================================================================
    -- NON-NAME SORTING: Use path_tokens approach (unchanged)
    -- ========================================================================
    IF v_order_by != 'name' THEN
        RETURN QUERY EXECUTE format(
            $sql$
            WITH folders AS (
                SELECT path_tokens[$1] AS folder
                FROM storage.objects
                WHERE objects.name ILIKE $2 || '%%'
                  AND bucket_id = $3
                  AND array_length(objects.path_tokens, 1) <> $1
                GROUP BY folder
                ORDER BY folder %s
            )
            (SELECT folder AS "name",
                   NULL::uuid AS id,
                   NULL::timestamptz AS updated_at,
                   NULL::timestamptz AS created_at,
                   NULL::timestamptz AS last_accessed_at,
                   NULL::jsonb AS metadata FROM folders)
            UNION ALL
            (SELECT path_tokens[$1] AS "name",
                   id, updated_at, created_at, last_accessed_at, metadata
             FROM storage.objects
             WHERE objects.name ILIKE $2 || '%%'
               AND bucket_id = $3
               AND array_length(objects.path_tokens, 1) = $1
             ORDER BY %I %s)
            LIMIT $4 OFFSET $5
            $sql$, v_sort_order, v_order_by, v_sort_order
        ) USING levels, v_prefix, bucketname, v_limit, offsets;
        RETURN;
    END IF;

    -- ========================================================================
    -- NAME SORTING: Hybrid skip-scan with batch optimization
    -- ========================================================================

    -- Calculate upper bound for prefix filtering
    IF v_prefix_lower = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix_lower, 1) = v_delimiter THEN
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(v_delimiter) + 1);
    ELSE
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(right(v_prefix_lower, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'AND lower(o.name) COLLATE "C" < $3 ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'AND lower(o.name) COLLATE "C" >= $3 ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- Initialize seek position
    IF v_is_asc THEN
        v_next_seek := v_prefix_lower;
    ELSE
        -- DESC: find the last item in range first (static SQL)
        IF v_upper_bound IS NOT NULL THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower AND lower(o.name) COLLATE "C" < v_upper_bound
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSIF v_prefix_lower <> '' THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSE
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        END IF;

        IF v_peek_name IS NOT NULL THEN
            v_next_seek := lower(v_peek_name) || v_delimiter;
        ELSE
            RETURN;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= v_limit;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix_lower <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(lower(v_peek_name), v_prefix_lower, v_delimiter);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Handle offset, emit if needed, skip to next folder
            IF v_skipped < offsets THEN
                v_skipped := v_skipped + 1;
            ELSE
                name := split_part(rtrim(storage.get_common_prefix(v_peek_name, v_prefix, v_delimiter), v_delimiter), v_delimiter, levels);
                id := NULL;
                updated_at := NULL;
                created_at := NULL;
                last_accessed_at := NULL;
                metadata := NULL;
                RETURN NEXT;
                v_count := v_count + 1;
            END IF;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := lower(left(v_common_prefix, -1)) || chr(ascii(v_delimiter) + 1);
            ELSE
                v_next_seek := lower(v_common_prefix);
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix_lower is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query
                USING bucketname, v_next_seek,
                    CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix_lower) ELSE v_prefix_lower END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(lower(v_current.name), v_prefix_lower, v_delimiter);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := lower(v_current.name);
                    EXIT;
                END IF;

                -- Handle offset skipping
                IF v_skipped < offsets THEN
                    v_skipped := v_skipped + 1;
                ELSE
                    -- Emit file
                    name := split_part(v_current.name, v_delimiter, levels);
                    id := v_current.id;
                    updated_at := v_current.updated_at;
                    created_at := v_current.created_at;
                    last_accessed_at := v_current.last_accessed_at;
                    metadata := v_current.metadata;
                    RETURN NEXT;
                    v_count := v_count + 1;
                END IF;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := lower(v_current.name) || v_delimiter;
                ELSE
                    v_next_seek := lower(v_current.name);
                END IF;

                EXIT WHEN v_count >= v_limit;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- TOC entry 483 (class 1255 OID 17355)
-- Name: search_by_timestamp(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_cursor_op text;
    v_query text;
    v_prefix text;
BEGIN
    v_prefix := coalesce(p_prefix, '');

    IF p_sort_order = 'asc' THEN
        v_cursor_op := '>';
    ELSE
        v_cursor_op := '<';
    END IF;

    v_query := format($sql$
        WITH raw_objects AS (
            SELECT
                o.name AS obj_name,
                o.id AS obj_id,
                o.updated_at AS obj_updated_at,
                o.created_at AS obj_created_at,
                o.last_accessed_at AS obj_last_accessed_at,
                o.metadata AS obj_metadata,
                storage.get_common_prefix(o.name, $1, '/') AS common_prefix
            FROM storage.objects o
            WHERE o.bucket_id = $2
              AND o.name COLLATE "C" LIKE $1 || '%%'
        ),
        -- Aggregate common prefixes (folders)
        -- Both created_at and updated_at use MIN(obj_created_at) to match the old prefixes table behavior
        aggregated_prefixes AS (
            SELECT
                rtrim(common_prefix, '/') AS name,
                NULL::uuid AS id,
                MIN(obj_created_at) AS updated_at,
                MIN(obj_created_at) AS created_at,
                NULL::timestamptz AS last_accessed_at,
                NULL::jsonb AS metadata,
                TRUE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NOT NULL
            GROUP BY common_prefix
        ),
        leaf_objects AS (
            SELECT
                obj_name AS name,
                obj_id AS id,
                obj_updated_at AS updated_at,
                obj_created_at AS created_at,
                obj_last_accessed_at AS last_accessed_at,
                obj_metadata AS metadata,
                FALSE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NULL
        ),
        combined AS (
            SELECT * FROM aggregated_prefixes
            UNION ALL
            SELECT * FROM leaf_objects
        ),
        filtered AS (
            SELECT *
            FROM combined
            WHERE (
                $5 = ''
                OR ROW(
                    date_trunc('milliseconds', %I),
                    name COLLATE "C"
                ) %s ROW(
                    COALESCE(NULLIF($6, '')::timestamptz, 'epoch'::timestamptz),
                    $5
                )
            )
        )
        SELECT
            split_part(name, '/', $3) AS key,
            name,
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
        FROM filtered
        ORDER BY
            COALESCE(date_trunc('milliseconds', %I), 'epoch'::timestamptz) %s,
            name COLLATE "C" %s
        LIMIT $4
    $sql$,
        p_sort_column,
        v_cursor_op,
        p_sort_column,
        p_sort_order,
        p_sort_order
    );

    RETURN QUERY EXECUTE v_query
    USING v_prefix, p_bucket_id, p_level, p_limit, p_start_after, p_sort_column_after;
END;
$_$;


ALTER FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) OWNER TO supabase_storage_admin;

--
-- TOC entry 482 (class 1255 OID 17354)
-- Name: search_v2(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, sort_column text DEFAULT 'name'::text, sort_column_after text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_sort_col text;
    v_sort_ord text;
    v_limit int;
BEGIN
    -- Cap limit to maximum of 1500 records
    v_limit := LEAST(coalesce(limits, 100), 1500);

    -- Validate and normalize sort_order
    v_sort_ord := lower(coalesce(sort_order, 'asc'));
    IF v_sort_ord NOT IN ('asc', 'desc') THEN
        v_sort_ord := 'asc';
    END IF;

    -- Validate and normalize sort_column
    v_sort_col := lower(coalesce(sort_column, 'name'));
    IF v_sort_col NOT IN ('name', 'updated_at', 'created_at') THEN
        v_sort_col := 'name';
    END IF;

    -- Route to appropriate implementation
    IF v_sort_col = 'name' THEN
        -- Use list_objects_with_delimiter for name sorting (most efficient: O(k * log n))
        RETURN QUERY
        SELECT
            split_part(l.name, '/', levels) AS key,
            l.name AS name,
            l.id,
            l.updated_at,
            l.created_at,
            l.last_accessed_at,
            l.metadata
        FROM storage.list_objects_with_delimiter(
            bucket_name,
            coalesce(prefix, ''),
            '/',
            v_limit,
            start_after,
            '',
            v_sort_ord
        ) l;
    ELSE
        -- Use aggregation approach for timestamp sorting
        -- Not efficient for large datasets but supports correct pagination
        RETURN QUERY SELECT * FROM storage.search_by_timestamp(
            prefix, bucket_name, v_limit, levels, start_after,
            v_sort_ord, v_sort_col, sort_column_after
        );
    END IF;
END;
$$;


ALTER FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer, levels integer, start_after text, sort_order text, sort_column text, sort_column_after text) OWNER TO supabase_storage_admin;

--
-- TOC entry 475 (class 1255 OID 17228)
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 311 (class 1259 OID 16529)
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- TOC entry 4577 (class 0 OID 0)
-- Dependencies: 311
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- TOC entry 330 (class 1259 OID 17084)
-- Name: custom_oauth_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.custom_oauth_providers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    provider_type text NOT NULL,
    identifier text NOT NULL,
    name text NOT NULL,
    client_id text NOT NULL,
    client_secret text NOT NULL,
    acceptable_client_ids text[] DEFAULT '{}'::text[] NOT NULL,
    scopes text[] DEFAULT '{}'::text[] NOT NULL,
    pkce_enabled boolean DEFAULT true NOT NULL,
    attribute_mapping jsonb DEFAULT '{}'::jsonb NOT NULL,
    authorization_params jsonb DEFAULT '{}'::jsonb NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    email_optional boolean DEFAULT false NOT NULL,
    issuer text,
    discovery_url text,
    skip_nonce_check boolean DEFAULT false NOT NULL,
    cached_discovery jsonb,
    discovery_cached_at timestamp with time zone,
    authorization_url text,
    token_url text,
    userinfo_url text,
    jwks_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT custom_oauth_providers_authorization_url_https CHECK (((authorization_url IS NULL) OR (authorization_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_authorization_url_length CHECK (((authorization_url IS NULL) OR (char_length(authorization_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_client_id_length CHECK (((char_length(client_id) >= 1) AND (char_length(client_id) <= 512))),
    CONSTRAINT custom_oauth_providers_discovery_url_length CHECK (((discovery_url IS NULL) OR (char_length(discovery_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_identifier_format CHECK ((identifier ~ '^[a-z0-9][a-z0-9:-]{0,48}[a-z0-9]$'::text)),
    CONSTRAINT custom_oauth_providers_issuer_length CHECK (((issuer IS NULL) OR ((char_length(issuer) >= 1) AND (char_length(issuer) <= 2048)))),
    CONSTRAINT custom_oauth_providers_jwks_uri_https CHECK (((jwks_uri IS NULL) OR (jwks_uri ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_jwks_uri_length CHECK (((jwks_uri IS NULL) OR (char_length(jwks_uri) <= 2048))),
    CONSTRAINT custom_oauth_providers_name_length CHECK (((char_length(name) >= 1) AND (char_length(name) <= 100))),
    CONSTRAINT custom_oauth_providers_oauth2_requires_endpoints CHECK (((provider_type <> 'oauth2'::text) OR ((authorization_url IS NOT NULL) AND (token_url IS NOT NULL) AND (userinfo_url IS NOT NULL)))),
    CONSTRAINT custom_oauth_providers_oidc_discovery_url_https CHECK (((provider_type <> 'oidc'::text) OR (discovery_url IS NULL) OR (discovery_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_issuer_https CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NULL) OR (issuer ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_requires_issuer CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NOT NULL))),
    CONSTRAINT custom_oauth_providers_provider_type_check CHECK ((provider_type = ANY (ARRAY['oauth2'::text, 'oidc'::text]))),
    CONSTRAINT custom_oauth_providers_token_url_https CHECK (((token_url IS NULL) OR (token_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_token_url_length CHECK (((token_url IS NULL) OR (char_length(token_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_userinfo_url_https CHECK (((userinfo_url IS NULL) OR (userinfo_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_userinfo_url_length CHECK (((userinfo_url IS NULL) OR (char_length(userinfo_url) <= 2048)))
);


ALTER TABLE auth.custom_oauth_providers OWNER TO supabase_auth_admin;

--
-- TOC entry 324 (class 1259 OID 16889)
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text,
    code_challenge_method auth.code_challenge_method,
    code_challenge text,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone,
    invite_token text,
    referrer text,
    oauth_client_state_id uuid,
    linking_target_id uuid,
    email_optional boolean DEFAULT false NOT NULL
);


ALTER TABLE auth.flow_state OWNER TO supabase_auth_admin;

--
-- TOC entry 4580 (class 0 OID 0)
-- Dependencies: 324
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.flow_state IS 'Stores metadata for all OAuth/SSO login flows';


--
-- TOC entry 315 (class 1259 OID 16686)
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- TOC entry 4582 (class 0 OID 0)
-- Dependencies: 315
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- TOC entry 4583 (class 0 OID 0)
-- Dependencies: 315
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- TOC entry 310 (class 1259 OID 16522)
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- TOC entry 4585 (class 0 OID 0)
-- Dependencies: 310
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- TOC entry 319 (class 1259 OID 16776)
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO supabase_auth_admin;

--
-- TOC entry 4587 (class 0 OID 0)
-- Dependencies: 319
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- TOC entry 318 (class 1259 OID 16764)
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


ALTER TABLE auth.mfa_challenges OWNER TO supabase_auth_admin;

--
-- TOC entry 4589 (class 0 OID 0)
-- Dependencies: 318
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- TOC entry 317 (class 1259 OID 16751)
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid,
    last_webauthn_challenge_data jsonb
);


ALTER TABLE auth.mfa_factors OWNER TO supabase_auth_admin;

--
-- TOC entry 4591 (class 0 OID 0)
-- Dependencies: 317
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- TOC entry 4592 (class 0 OID 0)
-- Dependencies: 317
-- Name: COLUMN mfa_factors.last_webauthn_challenge_data; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.mfa_factors.last_webauthn_challenge_data IS 'Stores the latest WebAuthn challenge data including attestation/assertion for customer verification';


--
-- TOC entry 327 (class 1259 OID 17001)
-- Name: oauth_authorizations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_authorizations (
    id uuid NOT NULL,
    authorization_id text NOT NULL,
    client_id uuid NOT NULL,
    user_id uuid,
    redirect_uri text NOT NULL,
    scope text NOT NULL,
    state text,
    resource text,
    code_challenge text,
    code_challenge_method auth.code_challenge_method,
    response_type auth.oauth_response_type DEFAULT 'code'::auth.oauth_response_type NOT NULL,
    status auth.oauth_authorization_status DEFAULT 'pending'::auth.oauth_authorization_status NOT NULL,
    authorization_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '00:03:00'::interval) NOT NULL,
    approved_at timestamp with time zone,
    nonce text,
    CONSTRAINT oauth_authorizations_authorization_code_length CHECK ((char_length(authorization_code) <= 255)),
    CONSTRAINT oauth_authorizations_code_challenge_length CHECK ((char_length(code_challenge) <= 128)),
    CONSTRAINT oauth_authorizations_expires_at_future CHECK ((expires_at > created_at)),
    CONSTRAINT oauth_authorizations_nonce_length CHECK ((char_length(nonce) <= 255)),
    CONSTRAINT oauth_authorizations_redirect_uri_length CHECK ((char_length(redirect_uri) <= 2048)),
    CONSTRAINT oauth_authorizations_resource_length CHECK ((char_length(resource) <= 2048)),
    CONSTRAINT oauth_authorizations_scope_length CHECK ((char_length(scope) <= 4096)),
    CONSTRAINT oauth_authorizations_state_length CHECK ((char_length(state) <= 4096))
);


ALTER TABLE auth.oauth_authorizations OWNER TO supabase_auth_admin;

--
-- TOC entry 329 (class 1259 OID 17074)
-- Name: oauth_client_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_client_states (
    id uuid NOT NULL,
    provider_type text NOT NULL,
    code_verifier text,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE auth.oauth_client_states OWNER TO supabase_auth_admin;

--
-- TOC entry 4595 (class 0 OID 0)
-- Dependencies: 329
-- Name: TABLE oauth_client_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.oauth_client_states IS 'Stores OAuth states for third-party provider authentication flows where Supabase acts as the OAuth client.';


--
-- TOC entry 326 (class 1259 OID 16971)
-- Name: oauth_clients; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_clients (
    id uuid NOT NULL,
    client_secret_hash text,
    registration_type auth.oauth_registration_type NOT NULL,
    redirect_uris text NOT NULL,
    grant_types text NOT NULL,
    client_name text,
    client_uri text,
    logo_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    client_type auth.oauth_client_type DEFAULT 'confidential'::auth.oauth_client_type NOT NULL,
    token_endpoint_auth_method text NOT NULL,
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048)),
    CONSTRAINT oauth_clients_token_endpoint_auth_method_check CHECK ((token_endpoint_auth_method = ANY (ARRAY['client_secret_basic'::text, 'client_secret_post'::text, 'none'::text])))
);


ALTER TABLE auth.oauth_clients OWNER TO supabase_auth_admin;

--
-- TOC entry 328 (class 1259 OID 17034)
-- Name: oauth_consents; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_consents (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    client_id uuid NOT NULL,
    scopes text NOT NULL,
    granted_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_at timestamp with time zone,
    CONSTRAINT oauth_consents_revoked_after_granted CHECK (((revoked_at IS NULL) OR (revoked_at >= granted_at))),
    CONSTRAINT oauth_consents_scopes_length CHECK ((char_length(scopes) <= 2048)),
    CONSTRAINT oauth_consents_scopes_not_empty CHECK ((char_length(TRIM(BOTH FROM scopes)) > 0))
);


ALTER TABLE auth.oauth_consents OWNER TO supabase_auth_admin;

--
-- TOC entry 325 (class 1259 OID 16939)
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


ALTER TABLE auth.one_time_tokens OWNER TO supabase_auth_admin;

--
-- TOC entry 309 (class 1259 OID 16511)
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- TOC entry 4600 (class 0 OID 0)
-- Dependencies: 309
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- TOC entry 308 (class 1259 OID 16510)
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- TOC entry 4602 (class 0 OID 0)
-- Dependencies: 308
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- TOC entry 322 (class 1259 OID 16818)
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO supabase_auth_admin;

--
-- TOC entry 4604 (class 0 OID 0)
-- Dependencies: 322
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- TOC entry 323 (class 1259 OID 16836)
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO supabase_auth_admin;

--
-- TOC entry 4606 (class 0 OID 0)
-- Dependencies: 323
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- TOC entry 312 (class 1259 OID 16537)
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- TOC entry 4608 (class 0 OID 0)
-- Dependencies: 312
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- TOC entry 316 (class 1259 OID 16716)
-- Name: sessions; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text,
    oauth_client_id uuid,
    refresh_token_hmac_key text,
    refresh_token_counter bigint,
    scopes text,
    CONSTRAINT sessions_scopes_length CHECK ((char_length(scopes) <= 4096))
);


ALTER TABLE auth.sessions OWNER TO supabase_auth_admin;

--
-- TOC entry 4610 (class 0 OID 0)
-- Dependencies: 316
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- TOC entry 4611 (class 0 OID 0)
-- Dependencies: 316
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- TOC entry 4612 (class 0 OID 0)
-- Dependencies: 316
-- Name: COLUMN sessions.refresh_token_hmac_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_hmac_key IS 'Holds a HMAC-SHA256 key used to sign refresh tokens for this session.';


--
-- TOC entry 4613 (class 0 OID 0)
-- Dependencies: 316
-- Name: COLUMN sessions.refresh_token_counter; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_counter IS 'Holds the ID (counter) of the last issued refresh token.';


--
-- TOC entry 321 (class 1259 OID 16803)
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO supabase_auth_admin;

--
-- TOC entry 4615 (class 0 OID 0)
-- Dependencies: 321
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- TOC entry 320 (class 1259 OID 16794)
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    disabled boolean,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO supabase_auth_admin;

--
-- TOC entry 4617 (class 0 OID 0)
-- Dependencies: 320
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- TOC entry 4618 (class 0 OID 0)
-- Dependencies: 320
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- TOC entry 307 (class 1259 OID 16499)
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- TOC entry 4620 (class 0 OID 0)
-- Dependencies: 307
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- TOC entry 4621 (class 0 OID 0)
-- Dependencies: 307
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- TOC entry 332 (class 1259 OID 17149)
-- Name: webauthn_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.webauthn_challenges (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    challenge_type text NOT NULL,
    session_data jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    CONSTRAINT webauthn_challenges_challenge_type_check CHECK ((challenge_type = ANY (ARRAY['signup'::text, 'registration'::text, 'authentication'::text])))
);


ALTER TABLE auth.webauthn_challenges OWNER TO supabase_auth_admin;

--
-- TOC entry 331 (class 1259 OID 17126)
-- Name: webauthn_credentials; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.webauthn_credentials (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    credential_id bytea NOT NULL,
    public_key bytea NOT NULL,
    attestation_type text DEFAULT ''::text NOT NULL,
    aaguid uuid,
    sign_count bigint DEFAULT 0 NOT NULL,
    transports jsonb DEFAULT '[]'::jsonb NOT NULL,
    backup_eligible boolean DEFAULT false NOT NULL,
    backed_up boolean DEFAULT false NOT NULL,
    friendly_name text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    last_used_at timestamp with time zone
);


ALTER TABLE auth.webauthn_credentials OWNER TO supabase_auth_admin;

--
-- TOC entry 348 (class 1259 OID 17545)
-- Name: daftar_pekerjaan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.daftar_pekerjaan (
    id integer NOT NULL,
    staf_nip character varying,
    semester_id integer,
    judul character varying,
    deskripsi text,
    tipe_pekerjaan_id integer,
    poin_jam double precision,
    kuota integer,
    ruangan_id integer,
    is_aktif boolean DEFAULT true,
    tanggal_mulai date,
    tanggal_selesai date,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.daftar_pekerjaan OWNER TO postgres;

--
-- TOC entry 349 (class 1259 OID 17552)
-- Name: daftar_pekerjaan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.daftar_pekerjaan ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.daftar_pekerjaan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 350 (class 1259 OID 17553)
-- Name: ekuivalensi_kelas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ekuivalensi_kelas (
    id integer NOT NULL,
    kelas_id integer,
    semester_id integer,
    penanggung_jawab_nim character varying,
    nota_url text,
    nominal_total numeric,
    jam_diakui double precision,
    status_ekuivalensi_id integer,
    verified_by_nip character varying,
    catatan text,
    created_at timestamp without time zone DEFAULT now(),
    no_telepon character varying,
    no_telepon_change_count integer DEFAULT 0,
    keterangan_pekerjaan text,
    link_barang text
);


ALTER TABLE public.ekuivalensi_kelas OWNER TO postgres;

--
-- TOC entry 351 (class 1259 OID 17560)
-- Name: ekuivalensi_kelas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.ekuivalensi_kelas ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.ekuivalensi_kelas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 352 (class 1259 OID 17561)
-- Name: gedung; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gedung (
    id integer NOT NULL,
    jurusan_id integer,
    nama_gedung character varying
);


ALTER TABLE public.gedung OWNER TO postgres;

--
-- TOC entry 353 (class 1259 OID 17566)
-- Name: gedung_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.gedung ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.gedung_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 354 (class 1259 OID 17567)
-- Name: import_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.import_log (
    id integer NOT NULL,
    staf_nip character varying,
    semester_id integer,
    nama_file character varying,
    total_baris integer,
    sukses_baris integer,
    error_details jsonb,
    status_import_id integer,
    created_at timestamp without time zone DEFAULT now(),
    file_hash character varying
);


ALTER TABLE public.import_log OWNER TO postgres;

--
-- TOC entry 355 (class 1259 OID 17573)
-- Name: import_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.import_log ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.import_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 356 (class 1259 OID 17574)
-- Name: jurusan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jurusan (
    id integer NOT NULL,
    nama_jurusan character varying
);


ALTER TABLE public.jurusan OWNER TO postgres;

--
-- TOC entry 357 (class 1259 OID 17579)
-- Name: jurusan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.jurusan ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.jurusan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 358 (class 1259 OID 17580)
-- Name: kelas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kelas (
    id integer NOT NULL,
    prodi_id integer,
    nama_kelas character varying
);


ALTER TABLE public.kelas OWNER TO postgres;

--
-- TOC entry 359 (class 1259 OID 17585)
-- Name: kelas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.kelas ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.kelas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 360 (class 1259 OID 17586)
-- Name: kompen_awal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kompen_awal (
    id integer NOT NULL,
    nim character varying,
    semester_id integer,
    import_id integer,
    total_jam_wajib double precision,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.kompen_awal OWNER TO postgres;

--
-- TOC entry 361 (class 1259 OID 17592)
-- Name: kompen_awal_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.kompen_awal ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.kompen_awal_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 362 (class 1259 OID 17593)
-- Name: log_potong_jam; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.log_potong_jam (
    id integer NOT NULL,
    nim character varying,
    semester_id integer,
    penugasan_id integer,
    ekuivalensi_id integer,
    jam_dikurangi double precision,
    keterangan text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone
);


ALTER TABLE public.log_potong_jam OWNER TO postgres;

--
-- TOC entry 363 (class 1259 OID 17599)
-- Name: log_potong_jam_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.log_potong_jam ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.log_potong_jam_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 364 (class 1259 OID 17600)
-- Name: mahasiswa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mahasiswa (
    nim character varying NOT NULL,
    user_id integer,
    nama character varying
);


ALTER TABLE public.mahasiswa OWNER TO postgres;

--
-- TOC entry 365 (class 1259 OID 17605)
-- Name: menus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.menus (
    id integer NOT NULL,
    key character varying NOT NULL,
    label character varying NOT NULL,
    icon character varying,
    path character varying NOT NULL,
    urutan integer DEFAULT 0,
    parent_id integer,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.menus OWNER TO postgres;

--
-- TOC entry 366 (class 1259 OID 17612)
-- Name: menus_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.menus ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.menus_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 367 (class 1259 OID 17613)
-- Name: pengaturan_sistem; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pengaturan_sistem (
    id integer NOT NULL,
    grup character varying,
    key character varying,
    value character varying,
    tipe_data character varying,
    keterangan text
);


ALTER TABLE public.pengaturan_sistem OWNER TO postgres;

--
-- TOC entry 368 (class 1259 OID 17618)
-- Name: pengaturan_sistem_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.pengaturan_sistem ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.pengaturan_sistem_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 369 (class 1259 OID 17619)
-- Name: penugasan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.penugasan (
    id integer NOT NULL,
    pekerjaan_id integer,
    nim character varying,
    status_tugas_id integer,
    detail_pengerjaan jsonb,
    catatan_verifikasi text,
    diverifikasi_oleh_nip character varying,
    waktu_verifikasi timestamp without time zone,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone
);


ALTER TABLE public.penugasan OWNER TO postgres;

--
-- TOC entry 370 (class 1259 OID 17625)
-- Name: penugasan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.penugasan ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.penugasan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 371 (class 1259 OID 17626)
-- Name: prodi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.prodi (
    id integer NOT NULL,
    jurusan_id integer,
    nama_prodi character varying
);


ALTER TABLE public.prodi OWNER TO postgres;

--
-- TOC entry 372 (class 1259 OID 17631)
-- Name: prodi_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.prodi ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.prodi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 373 (class 1259 OID 17632)
-- Name: ref_status_ekuivalensi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ref_status_ekuivalensi (
    id integer NOT NULL,
    nama character varying
);


ALTER TABLE public.ref_status_ekuivalensi OWNER TO postgres;

--
-- TOC entry 374 (class 1259 OID 17637)
-- Name: ref_status_import; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ref_status_import (
    id integer NOT NULL,
    nama character varying
);


ALTER TABLE public.ref_status_import OWNER TO postgres;

--
-- TOC entry 375 (class 1259 OID 17642)
-- Name: ref_status_tugas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ref_status_tugas (
    id integer NOT NULL,
    nama character varying
);


ALTER TABLE public.ref_status_tugas OWNER TO postgres;

--
-- TOC entry 376 (class 1259 OID 17647)
-- Name: ref_tipe_pekerjaan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ref_tipe_pekerjaan (
    id integer NOT NULL,
    nama character varying
);


ALTER TABLE public.ref_tipe_pekerjaan OWNER TO postgres;

--
-- TOC entry 377 (class 1259 OID 17652)
-- Name: registrasi_mahasiswa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.registrasi_mahasiswa (
    id integer NOT NULL,
    nim character varying,
    semester_id integer,
    kelas_id integer,
    status character varying DEFAULT 'Aktif'::character varying
);


ALTER TABLE public.registrasi_mahasiswa OWNER TO postgres;

--
-- TOC entry 378 (class 1259 OID 17658)
-- Name: registrasi_mahasiswa_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.registrasi_mahasiswa ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.registrasi_mahasiswa_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 379 (class 1259 OID 17659)
-- Name: role_has_menus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_has_menus (
    id smallint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    role_id integer,
    menus_id integer
);


ALTER TABLE public.role_has_menus OWNER TO postgres;

--
-- TOC entry 380 (class 1259 OID 17663)
-- Name: role_has_menus_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.role_has_menus ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.role_has_menus_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 381 (class 1259 OID 17664)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    nama character varying,
    key_menu jsonb,
    key_condition jsonb
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 382 (class 1259 OID 17669)
-- Name: ruangan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ruangan (
    id integer NOT NULL,
    gedung_id integer,
    nama_ruangan character varying,
    kode_ruangan character varying
);


ALTER TABLE public.ruangan OWNER TO postgres;

--
-- TOC entry 383 (class 1259 OID 17674)
-- Name: ruangan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.ruangan ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.ruangan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 384 (class 1259 OID 17675)
-- Name: semester; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.semester (
    id integer NOT NULL,
    nama character varying,
    tahun integer,
    periode character varying,
    is_aktif boolean DEFAULT false,
    mulai date,
    selesai date
);


ALTER TABLE public.semester OWNER TO postgres;

--
-- TOC entry 385 (class 1259 OID 17681)
-- Name: semester_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.semester ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.semester_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 386 (class 1259 OID 17682)
-- Name: staf; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.staf (
    nip character varying NOT NULL,
    user_id integer,
    nama character varying,
    jurusan_id integer,
    tipe_staf character varying
);


ALTER TABLE public.staf OWNER TO postgres;

--
-- TOC entry 387 (class 1259 OID 17687)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    email character varying,
    kata_sandi character varying,
    role_id integer,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 388 (class 1259 OID 17693)
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.users ALTER COLUMN user_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.users_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 389 (class 1259 OID 17694)
-- Name: v_mahasiswa_aktif; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_mahasiswa_aktif AS
 SELECT m.nim,
    m.nama,
    u.email,
    r.semester_id,
    r.status AS status_registrasi,
    k.nama_kelas,
    p.nama_prodi,
    j.nama_jurusan,
    s.is_aktif AS is_semester_aktif
   FROM ((((((public.mahasiswa m
     JOIN public.users u ON ((u.user_id = m.user_id)))
     JOIN public.registrasi_mahasiswa r ON (((r.nim)::text = (m.nim)::text)))
     JOIN public.semester s ON ((s.id = r.semester_id)))
     JOIN public.kelas k ON ((k.id = r.kelas_id)))
     JOIN public.prodi p ON ((p.id = k.prodi_id)))
     JOIN public.jurusan j ON ((j.id = p.jurusan_id)));


ALTER VIEW public.v_mahasiswa_aktif OWNER TO postgres;

--
-- TOC entry 390 (class 1259 OID 17699)
-- Name: v_sisa_kompen; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_sisa_kompen AS
 SELECT k.nim,
    k.semester_id,
    k.total_jam_wajib,
    COALESCE(sum(l.jam_dikurangi), (0)::double precision) AS jam_selesai,
    (k.total_jam_wajib - COALESCE(sum(l.jam_dikurangi), (0)::double precision)) AS sisa_jam
   FROM (public.kompen_awal k
     LEFT JOIN public.log_potong_jam l ON ((((l.nim)::text = (k.nim)::text) AND (l.semester_id = k.semester_id))))
  GROUP BY k.nim, k.semester_id, k.total_jam_wajib;


ALTER VIEW public.v_sisa_kompen OWNER TO postgres;

--
-- TOC entry 391 (class 1259 OID 17704)
-- Name: v_status_pekerjaan; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_status_pekerjaan AS
SELECT
    NULL::integer AS pekerjaan_id,
    NULL::character varying AS judul,
    NULL::integer AS kuota,
    NULL::double precision AS poin_jam,
    NULL::boolean AS is_aktif,
    NULL::bigint AS kuota_terisi,
    NULL::bigint AS sisa_slot;


ALTER VIEW public.v_status_pekerjaan OWNER TO postgres;

--
-- TOC entry 347 (class 1259 OID 17523)
-- Name: messages; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea
)
PARTITION BY RANGE (inserted_at);


ALTER TABLE realtime.messages OWNER TO supabase_realtime_admin;

--
-- TOC entry 333 (class 1259 OID 17170)
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE realtime.schema_migrations OWNER TO supabase_admin;

--
-- TOC entry 344 (class 1259 OID 17383)
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    action_filter text DEFAULT '*'::text,
    selected_columns text[],
    CONSTRAINT subscription_action_filter_check CHECK ((action_filter = ANY (ARRAY['*'::text, 'INSERT'::text, 'UPDATE'::text, 'DELETE'::text])))
);


ALTER TABLE realtime.subscription OWNER TO supabase_admin;

--
-- TOC entry 343 (class 1259 OID 17382)
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 335 (class 1259 OID 17183)
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text,
    type storage.buckettype DEFAULT 'STANDARD'::storage.buckettype NOT NULL
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- TOC entry 4675 (class 0 OID 0)
-- Dependencies: 335
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- TOC entry 339 (class 1259 OID 17302)
-- Name: buckets_analytics; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_analytics (
    name text NOT NULL,
    type storage.buckettype DEFAULT 'ANALYTICS'::storage.buckettype NOT NULL,
    format text DEFAULT 'ICEBERG'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE storage.buckets_analytics OWNER TO supabase_storage_admin;

--
-- TOC entry 340 (class 1259 OID 17315)
-- Name: buckets_vectors; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_vectors (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'VECTOR'::storage.buckettype NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.buckets_vectors OWNER TO supabase_storage_admin;

--
-- TOC entry 334 (class 1259 OID 17175)
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- TOC entry 336 (class 1259 OID 17193)
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- TOC entry 4679 (class 0 OID 0)
-- Dependencies: 336
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- TOC entry 337 (class 1259 OID 17242)
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb,
    metadata jsonb
);


ALTER TABLE storage.s3_multipart_uploads OWNER TO supabase_storage_admin;

--
-- TOC entry 338 (class 1259 OID 17256)
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.s3_multipart_uploads_parts OWNER TO supabase_storage_admin;

--
-- TOC entry 341 (class 1259 OID 17325)
-- Name: vector_indexes; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.vector_indexes (
    id text DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    bucket_id text NOT NULL,
    data_type text NOT NULL,
    dimension integer NOT NULL,
    distance_metric text NOT NULL,
    metadata_configuration jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.vector_indexes OWNER TO supabase_storage_admin;

--
-- TOC entry 3800 (class 2604 OID 16514)
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- TOC entry 4404 (class 0 OID 16529)
-- Dependencies: 311
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
\.


--
-- TOC entry 4421 (class 0 OID 17084)
-- Dependencies: 330
-- Data for Name: custom_oauth_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.custom_oauth_providers (id, provider_type, identifier, name, client_id, client_secret, acceptable_client_ids, scopes, pkce_enabled, attribute_mapping, authorization_params, enabled, email_optional, issuer, discovery_url, skip_nonce_check, cached_discovery, discovery_cached_at, authorization_url, token_url, userinfo_url, jwks_uri, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4415 (class 0 OID 16889)
-- Dependencies: 324
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at, invite_token, referrer, oauth_client_state_id, linking_target_id, email_optional) FROM stdin;
\.


--
-- TOC entry 4406 (class 0 OID 16686)
-- Dependencies: 315
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
\.


--
-- TOC entry 4403 (class 0 OID 16522)
-- Dependencies: 310
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4410 (class 0 OID 16776)
-- Dependencies: 319
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
\.


--
-- TOC entry 4409 (class 0 OID 16764)
-- Dependencies: 318
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- TOC entry 4408 (class 0 OID 16751)
-- Dependencies: 317
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid, last_webauthn_challenge_data) FROM stdin;
\.


--
-- TOC entry 4418 (class 0 OID 17001)
-- Dependencies: 327
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_authorizations (id, authorization_id, client_id, user_id, redirect_uri, scope, state, resource, code_challenge, code_challenge_method, response_type, status, authorization_code, created_at, expires_at, approved_at, nonce) FROM stdin;
\.


--
-- TOC entry 4420 (class 0 OID 17074)
-- Dependencies: 329
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_client_states (id, provider_type, code_verifier, created_at) FROM stdin;
\.


--
-- TOC entry 4417 (class 0 OID 16971)
-- Dependencies: 326
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_clients (id, client_secret_hash, registration_type, redirect_uris, grant_types, client_name, client_uri, logo_uri, created_at, updated_at, deleted_at, client_type, token_endpoint_auth_method) FROM stdin;
\.


--
-- TOC entry 4419 (class 0 OID 17034)
-- Dependencies: 328
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_consents (id, user_id, client_id, scopes, granted_at, revoked_at) FROM stdin;
\.


--
-- TOC entry 4416 (class 0 OID 16939)
-- Dependencies: 325
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4402 (class 0 OID 16511)
-- Dependencies: 309
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
\.


--
-- TOC entry 4413 (class 0 OID 16818)
-- Dependencies: 322
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- TOC entry 4414 (class 0 OID 16836)
-- Dependencies: 323
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- TOC entry 4405 (class 0 OID 16537)
-- Dependencies: 312
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
20250717082212
20250731150234
20250804100000
20250901200500
20250903112500
20250904133000
20250925093508
20251007112900
20251104100000
20251111201300
20251201000000
20260115000000
20260121000000
20260219120000
20260302000000
\.


--
-- TOC entry 4407 (class 0 OID 16716)
-- Dependencies: 316
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag, oauth_client_id, refresh_token_hmac_key, refresh_token_counter, scopes) FROM stdin;
\.


--
-- TOC entry 4412 (class 0 OID 16803)
-- Dependencies: 321
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4411 (class 0 OID 16794)
-- Dependencies: 320
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at, disabled) FROM stdin;
\.


--
-- TOC entry 4400 (class 0 OID 16499)
-- Dependencies: 307
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
\.


--
-- TOC entry 4423 (class 0 OID 17149)
-- Dependencies: 332
-- Data for Name: webauthn_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.webauthn_challenges (id, user_id, challenge_type, session_data, created_at, expires_at) FROM stdin;
\.


--
-- TOC entry 4422 (class 0 OID 17126)
-- Dependencies: 331
-- Data for Name: webauthn_credentials; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.webauthn_credentials (id, user_id, credential_id, public_key, attestation_type, aaguid, sign_count, transports, backup_eligible, backed_up, friendly_name, created_at, updated_at, last_used_at) FROM stdin;
\.


--
-- TOC entry 4435 (class 0 OID 17545)
-- Dependencies: 348
-- Data for Name: daftar_pekerjaan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.daftar_pekerjaan (id, staf_nip, semester_id, judul, deskripsi, tipe_pekerjaan_id, poin_jam, kuota, ruangan_id, is_aktif, tanggal_mulai, tanggal_selesai, created_at) FROM stdin;
2	197501012005011001	1	Pembersihan Lab Komputer	Membersihkan dan merapikan lab komputer setelah praktikum	2	1	10	3	t	2024-09-15	2024-12-15	2026-04-20 16:48:48.570326
3	197502022006021002	1	Pengolahan Data Keuangan	Membantu entry data transaksi keuangan	1	1.5	3	7	t	2024-09-10	2024-10-31	2026-04-20 16:48:48.570326
8	197503032007031003	1	Maintenance Website Jurusan	Update konten dan perbaikan bug website	1	2.5	2	12	t	2024-09-10	2024-12-31	2026-04-20 16:48:48.570326
9	197501012005011001	1	Pengelolaan Surat Menyurat	Membantu administrasi surat di jurusan	1	1	4	5	t	2024-09-10	2024-12-31	2026-04-20 16:48:48.570326
4	197503032007031003	1	Tutor Mahasiswa Baru	Membimbing mahasiswa baru dalam adaptasi perkuliahan	2	3	8	9	t	2024-09-20	2024-11-20	2026-04-20 16:48:48.570326
5	197501012005011001	1	Survey Kepuasan Mahasiswa	Menyebarkan dan mengumpulkan kuesioner	1	1	15	5	t	2024-10-01	2024-10-30	2026-04-20 16:48:48.570326
6	198001042008041001	1	Asisten Praktikum Algoritma	Membantu dosen dalam praktikum algoritma	2	4	5	9	t	2024-09-10	2024-12-10	2026-04-20 16:48:48.570326
7	198002052009051002	1	Penelitian Dosen	Membantu pengumpulan data penelitian	1	2	3	11	t	2024-09-25	2024-11-25	2026-04-20 16:48:48.570326
11	197501012005011001	1	farrel basudewa	mcgg	1	9	5	10	t	2026-05-04	2026-05-05	2026-05-04 05:38:38.602
12	197501012005011001	1	test pekerjaan	test desk pekerjaan	1	6	1	8	t	2026-05-05	2026-05-07	2026-05-05 07:53:01.254
10	197502022006021002	1	Pendampingan UMKM	Mendampingi UMKM binaan fakultas	2	3	5	7	t	2024-02-15	2024-05-15	2026-04-20 16:48:48.570326
1	197501012005011001	1	Pendataan Buku Perpustakaan	Membantu mendata dan menginventarisasi buku-buku di perpustakaan	1	3	5	1	t	2024-09-10	2024-10-10	2026-04-20 16:48:48.570326
13	197501012005011001	1	test	234dfd	1	4	2	7	t	2026-05-10	2026-05-25	2026-05-10 16:26:11.828
14	197501012005011001	1	testing kerjaan	tmynhrbr	1	6	3	1	t	2026-05-14	2026-05-26	2026-05-26 06:18:12.979
\.


--
-- TOC entry 4437 (class 0 OID 17553)
-- Dependencies: 350
-- Data for Name: ekuivalensi_kelas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ekuivalensi_kelas (id, kelas_id, semester_id, penanggung_jawab_nim, nota_url, nominal_total, jam_diakui, status_ekuivalensi_id, verified_by_nip, catatan, created_at, no_telepon, no_telepon_change_count, keterangan_pekerjaan, link_barang) FROM stdin;
26	19	1	\N	/nota/26-1779551812466.png	1616000	808	1	\N	Auto-generated: mahasiswa tidak mendapat/mengerjakan tugas	2026-05-21 08:49:48.148	082137681508	4	ghhgg	\N
31	24	1	\N	\N	912000	456	1	\N	Auto-generated: mahasiswa tidak mendapat/mengerjakan tugas	2026-05-21 08:49:48.163	02347823432	1	gg	\N
24	16	1	\N	/nota/24-1779776998868.png	992000	496	2	STAF001	\N	2026-05-21 08:49:48.107	08656464343	1	mabar legenda seluler	https://www.akbar.com
25	18	1	\N	\N	496000	248	1	\N	Auto-generated: mahasiswa tidak mendapat/mengerjakan tugas	2026-05-21 08:49:48.144	\N	0	\N	\N
27	20	1	\N	\N	112000	56	1	\N	Auto-generated: mahasiswa tidak mendapat/mengerjakan tugas	2026-05-21 08:49:48.15	\N	0	\N	\N
29	22	1	\N	\N	240000	120	1	\N	Auto-generated: mahasiswa tidak mendapat/mengerjakan tugas	2026-05-21 08:49:48.156	\N	0	\N	\N
30	23	1	\N	/nota/30-1779689462359.pdf	336000	168	1	\N	Auto-generated: mahasiswa tidak mendapat/mengerjakan tugas	2026-05-21 08:49:48.16	082137681509	1	\N	\N
32	17	1	\N	\N	32000	16	1	\N	Auto-generated: mahasiswa tidak mendapat/mengerjakan tugas	2026-05-26 06:24:16.114	\N	0	\N	\N
28	21	1	\N	/nota/28-1781155361292.png	208000	104	2	STAF001	\N	2026-05-21 08:49:48.152	0646442245455	1	beli ayam 	https://www.katalogi.web.id
\.


--
-- TOC entry 4439 (class 0 OID 17561)
-- Dependencies: 352
-- Data for Name: gedung; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.gedung (id, jurusan_id, nama_gedung) FROM stdin;
1	1	Gedung Teknik A
2	1	Gedung Teknik B
3	2	Gedung Ekonomi
4	3	Gedung Ilkom
5	4	Gedung Hukum
6	1	Laboratorium Pusat
7	3	Gedung Digital Center
\.


--
-- TOC entry 4441 (class 0 OID 17567)
-- Dependencies: 354
-- Data for Name: import_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.import_log (id, staf_nip, semester_id, nama_file, total_baris, sukses_baris, error_details, status_import_id, created_at, file_hash) FROM stdin;
1	197501012005011001	1	import_mahasiswa_ganjil_2024.xlsx	100	98	{"errors": ["Baris 5: NIM duplikat", "Baris 23: Nama kosong"]}	1	2024-08-20 09:30:00	\N
2	197501012005011001	1	import_kompen_awal_ganjil_2024.csv	150	150	\N	1	2024-08-21 10:15:00	\N
5	197501012005011001	3	data_lama_2023.xlsx	200	200	\N	1	2023-08-15 08:45:00	\N
9	197501012005011001	1	kompen-mhs-TI-1A.xlsx	226	226	null	1	2026-05-03 13:34:10.664	\N
10	197501012005011001	1	kompen-mhs-TI-1A.xlsx	226	226	null	1	2026-05-04 07:32:27.339	\N
11	197501012005011001	1	kompen-mhs-TI-1A.xlsx	226	226	null	1	2026-05-05 07:51:45.433	\N
12	197501012005011001	1	kompen-mhs-TI-1A.xlsx	226	226	null	1	2026-05-07 06:32:53.839	\N
13	197501012005011001	1	kompen-mhs-TI-1A.xlsx	226	226	null	1	2026-05-11 08:13:36.044	\N
3	197502022006021002	1	import_ekuivalensi.xlsx	25	23	{"errors": ["Baris 7: Kelas tidak ditemukan"]}	2	2024-09-01 14:20:00	\N
4	197503032007031003	2	import_mahasiswa_genap_2024.csv	95	90	{"errors": ["Baris 12: NIM tidak valid"]}	2	2024-01-10 11:00:00	\N
6	197501012005011001	1	kompen-mhs-TI-1A.xlsx	226	0	[{"nim": "4.33.25.0.01", "nama": "Aisa Reta Lestari", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.02", "nama": "ANDRIAN AMIRUDIN RAHMANTO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.03", "nama": "ANNISA NUR FARIKHA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.04", "nama": "CHOIRUL RAISSA PASHA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.05", "nama": "CHRISTYAN FABIANO YEHEZKIEL", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.06", "nama": "DASI HAYU PERMANA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.07", "nama": "DIMAS BAYU PRATAMA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.08", "nama": "DZIDAN ADRIAN FIRMANSYAH", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.09", "nama": "HERDIN SAVIRA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.10", "nama": "IRSYAD ZAKI RAMDHANI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.11", "nama": "KAVINDRA VABRIANANDA PUTRA MAHESWARA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.12", "nama": "KYLA CHAVELA EVANGELISTA WANGET", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.13", "nama": "MIKHAEL SURYA ADEPUTRA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.14", "nama": "MOH FAREL AGUSTIN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.15", "nama": "MUHAMMAD FAIQ AUDAH", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.16", "nama": "MUHAMMAD FAIZ FIRMANSYAH", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.17", "nama": "MUHAMMAD FAQIH RAMADHAN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.18", "nama": "NUR AINI WIDIYANTI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.19", "nama": "PRANAJA LUTHFI BELIAN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.20", "nama": "RAFAEL MARCELLO DWI NANDA BORO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.21", "nama": "RASYA NAUFAL HARLIANDRA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.22", "nama": "RIKI ULIR NIAM", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.23", "nama": "SEANIRMA AIDA CANDRAWATI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.24", "nama": "TEGAR BAGUS SATRIA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.25", "nama": "VICTOR ABDIEL KURNIAWAN RARES", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.01", "nama": "AHMAD FAJRIL FALAH", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.02", "nama": "ALIFANDI AHMAD SURYAWAN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.03", "nama": "ANISA AULIA NURUSYIFA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.04", "nama": "ARINDA LUSYANA DEWI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.05", "nama": "BIMO RADYNDRA PRAMASARA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.06", "nama": "DAFFA ARMADHAN HIDMI MA'ARIF", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.07", "nama": "DARRYLL MARCHIAND MUCHAMMAD NAUVAL I", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.08", "nama": "DEA CANTIKA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.09", "nama": "GALIH VIRGI PRAMUDYA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.10", "nama": "INAYAH CIKAL NURSHABRINA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.11", "nama": "IVAN SIGIT SANTOSO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.12", "nama": "KURNIA ANGGA DIMAS PRATAMA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.13", "nama": "LUKMAN ARIF WICAKSONO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.14", "nama": "MAULIDYA NURUL MUHARROMAH", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.15", "nama": "MUHAMMAD ARYA BIMA SURYA PRATAMA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.16", "nama": "MUHAMMAD DZAKYY AN NAFI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.17", "nama": "Muhammad Irfan", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.18", "nama": "MUHAMMAD RHAFI HAIRY MUSLIM", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.19", "nama": "MUKHLISH PRATAMA MULYA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.20", "nama": "RAHMA APRILLIANA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.21", "nama": "RASYA PANDU WICAKSONO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.22", "nama": "REVO SETYO KINASIH", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.23", "nama": "RIDHO ARSYIL HAKIM", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.24", "nama": "RITA YULIA SARI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.25", "nama": "RIZKY ADITYA WIJAYA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.26", "nama": "VANNISA ALDIRA KIRANI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.01", "nama": "AANG KUNADI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.02", "nama": "ALVIAN REZA MAHARDIKA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.03", "nama": "AMANDA CHRISTINA SITUMORANG", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.04", "nama": "AZKA GALUH BASUKI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.05", "nama": "BAGAS IDDEN LISTIYANTO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.06", "nama": "CHEETAH AMRULLAH SWASTIKA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.07", "nama": "DELA FAJAR MULIA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.08", "nama": "EVAN OCTAVIAN RAMADHAN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.09", "nama": "HADZIQ VINU MUFIDANY", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.10", "nama": "IRGI AKBAR FAHLEVI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.11", "nama": "JATMIKO SATRIO WIBOWO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.12", "nama": "LAKSAMANA AGUNG HADI NUGROHO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.13", "nama": "MILADIYAH ARINAL HAQ", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.14", "nama": "MUHAMMAD BARUNA SAYLENDRA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.15", "nama": "MUHAMMAD FADHIL", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.16", "nama": "NAUFAL AZKA FADHLILLAH", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.17", "nama": "NAZIFA CITRA NURVIANI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.18", "nama": "NIA SELVIA MAHDALENA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.19", "nama": "REIGZA NASYA PRATITHA RINGGIANI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.20", "nama": "RIZKY AKBAR ARDIANSYAH", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.21", "nama": "SATRIA HATIM MARRENTO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.22", "nama": "THOMAS ANDROMEDA ELANG BUANA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.23", "nama": "ULFAN NAYAKA DIPTA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.24", "nama": "YUSUF RICKY HARTONO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.25", "nama": "ZIYAUL FALAH", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.01", "nama": "ABIMANYU GILAR WALUYO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.02", "nama": "AHMAD CHOMSIN SYAHFRUDDIN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.03", "nama": "AISY TSABITA AMRU", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.04", "nama": "AKBAR HAKIM MUZAKY", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.05", "nama": "ALFIN ROZZAQ NIRWANA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.06", "nama": "ANISA NURWAHIDAH", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.07", "nama": "BASITH ANUGRAH YAFI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.08", "nama": "BENAYYA NOHAN ADMIRALDO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.09", "nama": "DANISH MAHDI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.10", "nama": "EGIE AMILIA VELISDIONO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.11", "nama": "FEBY YUANGGI PUTRI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.12", "nama": "HANIF ALBANA ROZAD", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.13", "nama": "INDRA WIJAYA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.14", "nama": "JONATHAN EDWARD SINAGA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.15", "nama": "KATRINA AGNI HARTANTO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.16", "nama": "MUHAMMAD ALMAHDI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.17", "nama": "MUHAMMAD FAISAL REZA MUSTOFA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.18", "nama": "MUHAMMAD RIZKY FADHILA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.19", "nama": "MUHAMMAD SYAUQI ALGHIFARI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.20", "nama": "NABILA RAMADANI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.21", "nama": "NANDA ARIFIA CHOERUNISA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.22", "nama": "RAFIF ALI FAHREZI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.23", "nama": "RAKI ABHISTA PRAKOSO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.24", "nama": "SALMA ZAHRA RAMADHANI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.25", "nama": "SATRIO ADZI PRIAMBODO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.26", "nama": "VIAN MAULANA RAMADHAN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.01", "nama": "ANISA FARCHA NOVIANI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.02", "nama": "ARJUNA NATHA PRATISENA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.03", "nama": "ARYODIMAS DZAKI WITRYAWAN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.04", "nama": "AZKA BARIQLANA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.05", "nama": "CAHYO GADHANG PUTRO BASKORO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.06", "nama": "CANTIKA ALIFIA MAHARANI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.07", "nama": "DEWANGGA RADITYA NUGROHO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.08", "nama": "EIREN WIBI HIDAYAT", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.09", "nama": "GANANG SYAIFULLAH", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.10", "nama": "HAFIZH IMAN WICAKSONO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.11", "nama": "KENCANA IKHSANUN NADJA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.12", "nama": "KHANSA INTANIA UTOMO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.13", "nama": "MI. AULIA KURNIA WIDYARANI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.14", "nama": "MUHAMMAD ASDIF AFADA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.15", "nama": "MUHAMMAD BINTANG SATRIO UTOMO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.16", "nama": "MUHAMMAD ILHAM RIJAL THAARIQ", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.17", "nama": "MUHAMMAD MUMTAZA AL AFKAR", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.18", "nama": "NAJWA RAHMA HAPSARI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.19", "nama": "PANDU SETYA NUGRAHA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.20", "nama": "PUTRI LEVINA AGATHA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.21", "nama": "RAUL HARYO FAUZIAN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.22", "nama": "RAY EGANS PRAMUDYA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.23", "nama": "RIKO ADITYA ZAKI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.24", "nama": "SENDI PRASETYO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.25", "nama": "SEPTIA ISNAENI SALSABILA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.26", "nama": "YUSUF FADHLIH FIRMANSYAH", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.01", "nama": "ABYAN FAZA NARISWANGGA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.02", "nama": "ADILA DIMAZ BUWANA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.03", "nama": "ANNISA NAELIL IZATI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.04", "nama": "BAGASKARA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.05", "nama": "CEZAR NARESWARA RESPATI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.06", "nama": "DEVI IBNU NABILA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.07", "nama": "DIAH DWI ASTUTI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.08", "nama": "DIMAS ADHIE NUGROHO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.10", "nama": "GHUFRON AINUN NAJIB", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.11", "nama": "IZZA BAGHUZ SYAFI'I MA'ARIF", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.12", "nama": "M. OKSA SETYARSO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.13", "nama": "MUHAMMAD HIKMAL ALFARIDZY BACHTIAR", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.14", "nama": "MUHAMMAD IBRAHIM", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.15", "nama": "MUHAMMAD RAFA ENRICO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.16", "nama": "NABILA AZ ZAHRA MUNIR", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.17", "nama": "PAULUS ALE KRISTIAWAN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.18", "nama": "RAJABA HAMIM MAUDUDI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.19", "nama": "RIZTIKA MERISTA INDRIANI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.20", "nama": "ROIHAN SAPUTRA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.21", "nama": "SITI MIFTAHUS SA'DIYAH", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.22", "nama": "SRI PUJANGGA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.23", "nama": "TERRA SURYA NEGARI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.24", "nama": "ZALFA AZ ZAHRA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.25", "nama": "ZULFIKRI ARYA PUTRA ISMAIL", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.01", "nama": "ADRIANSYAH ALFARISYI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.02", "nama": "AGUNG HADI ASTANTO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.03", "nama": "AHMAD FARKHANI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.04", "nama": "ANINDHA CAHYA MULIA SALIM", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.05", "nama": "ARIF KURNIA RAHMAN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.06", "nama": "ATHAYA PANDU MARENO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.07", "nama": "DANIEL ADI PRATAMA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.08", "nama": "DAVIN ALIFIANDA ADYTIA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.09", "nama": "FAJAR DWI FIRMANSYAH", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.10", "nama": "FITRIANA NAYLA NOVIANTI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.11", "nama": "GILANG MAULANATA PRAMUDYA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.13", "nama": "ILHAM TARUPRASETYO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.14", "nama": "IRMA INNAYAH", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.15", "nama": "KHILDA SALSABILA AZKA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.16", "nama": "MARVELLINA DEVI WURDHANING", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.17", "nama": "MAULANA FAJAR ROHMANI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.18", "nama": "MILA ROSITA DEWI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.19", "nama": "MUHAMAD HAYDAR AYDIN ALHAMDANI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.20", "nama": "MUHAMMAD SYAUQI MAULANA ANANSYAH", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.21", "nama": "MUHAMMAD ZAKIY FADHLULLAH AZHAR", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.22", "nama": "RACHMAD YOGO DWIYANTO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.23", "nama": "RAFI ARTHAYANA PUTRA DERIZMA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.26", "nama": "TUBAGUS PRATAMA JULIANTO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.22.1.25", "nama": "TITO WAHYU PRATAMA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.01", "nama": "AHMAD RIZKIADI BUDI WIRAWAN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.02", "nama": "AKSOBHYA SAMATHA VARGA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.03", "nama": "ANINDITA NAJWA EKA SABRINA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.04", "nama": "ATSIILA ARYA NABIIH", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.05", "nama": "AZANI FATTUR FADHIKA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.06", "nama": "DANU ALAMSYAH PUTRA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.07", "nama": "FAISHAL ANANDA RACHMAN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.08", "nama": "FAJAR WAHYU SURYAPUTRA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.09", "nama": "HANIF ABDUSY SYAKUR", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.10", "nama": "HELSA CHRISTABEL HARSONO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.11", "nama": "IBRAHIM ARYAN FARIDZI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.12", "nama": "IVAN RAKHA ADINATA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.13", "nama": "JONATHAN ORDRICK EDRA WIJAYA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.15", "nama": "MIFTACHUSSURUR", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.16", "nama": "MUHAMAD RIFKI SURYA PRATAMA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.17", "nama": "MUHAMMAD FATWA SYAIKHONI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.18", "nama": "MUHAMMAD RAFIF PASYA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.19", "nama": "NICHOLAS ERNESTO ANAK AGUNG", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.20", "nama": "RAHMALYANA AYUNINGTYAS", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.21", "nama": "RASYAD TANZILUR RAHMAN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.22", "nama": "ROHIMATUN NURIN NADHIFAH", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.23", "nama": "TARISHA NAILA ANGELIN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.24", "nama": "TRISTAN EKA WIRANATA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.25", "nama": "WARSENO BAMBANG SETYONO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.01", "nama": "ADINDA RAHIMAH AZZAHRA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.02", "nama": "ADJIE RADHITYA KUSSENA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.03", "nama": "ADNAN BIMA ADHI NUGRAHA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.04", "nama": "ALDO RAMADHANA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.05", "nama": "AMMAR LUQMAN ARIFIN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.06", "nama": "ANINDITA RAHMA AZALIA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.07", "nama": "AZKA NUR FADEL", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.08", "nama": "BAGUS SADEWA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.09", "nama": "CHALLISTA RISKIANA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.10", "nama": "DIRGA PRIYANTO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.11", "nama": "FAIZ AKMAL NURHAKIM", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.12", "nama": "FATHURRAFI NADIO BUSONO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.13", "nama": "GHAFARI ARIF JABBAR", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.14", "nama": "HASNA RUMAISHA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.15", "nama": "ILHAM AJI IRAWAN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.16", "nama": "ILHAM INDRA ATMAJA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.17", "nama": "MUHAMAD ZA'IM SETYAWAN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.18", "nama": "MUHAMMAD DZAKY JAMALUDDIN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.19", "nama": "MUHAMMAD HAIDAR ALY", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.20", "nama": "MUHAMMAD IMAM MUSTOFA KAMAL", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.21", "nama": "MUHAMMAD JANUAR RIFQI NANDA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.22", "nama": "MUHAMMAD ROOZIQIN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.23", "nama": "PRABASWARA SHAFA AZARIOMA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.24", "nama": "SAHARDIAN PUTRA WIGUNA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.25", "nama": "SALWA SALSABILA DAFFA'ATULHAQ", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.26", "nama": "ZULVIKAR KHARISMA NUR MUHAMMAD", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}]	2	2026-05-03 13:14:36.445	\N
7	197501012005011001	1	kompen-mhs-TI-1A.xlsx	226	0	[{"nim": "4.33.25.0.01", "nama": "Aisa Reta Lestari", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.02", "nama": "ANDRIAN AMIRUDIN RAHMANTO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.03", "nama": "ANNISA NUR FARIKHA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.04", "nama": "CHOIRUL RAISSA PASHA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.05", "nama": "CHRISTYAN FABIANO YEHEZKIEL", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.06", "nama": "DASI HAYU PERMANA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.07", "nama": "DIMAS BAYU PRATAMA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.08", "nama": "DZIDAN ADRIAN FIRMANSYAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.09", "nama": "HERDIN SAVIRA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.10", "nama": "IRSYAD ZAKI RAMDHANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.11", "nama": "KAVINDRA VABRIANANDA PUTRA MAHESWARA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.12", "nama": "KYLA CHAVELA EVANGELISTA WANGET", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.13", "nama": "MIKHAEL SURYA ADEPUTRA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.14", "nama": "MOH FAREL AGUSTIN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.15", "nama": "MUHAMMAD FAIQ AUDAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.16", "nama": "MUHAMMAD FAIZ FIRMANSYAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.17", "nama": "MUHAMMAD FAQIH RAMADHAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.18", "nama": "NUR AINI WIDIYANTI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.19", "nama": "PRANAJA LUTHFI BELIAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.20", "nama": "RAFAEL MARCELLO DWI NANDA BORO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.21", "nama": "RASYA NAUFAL HARLIANDRA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.22", "nama": "RIKI ULIR NIAM", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.23", "nama": "SEANIRMA AIDA CANDRAWATI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.24", "nama": "TEGAR BAGUS SATRIA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.25", "nama": "VICTOR ABDIEL KURNIAWAN RARES", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.01", "nama": "AHMAD FAJRIL FALAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.02", "nama": "ALIFANDI AHMAD SURYAWAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.03", "nama": "ANISA AULIA NURUSYIFA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.04", "nama": "ARINDA LUSYANA DEWI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.05", "nama": "BIMO RADYNDRA PRAMASARA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.06", "nama": "DAFFA ARMADHAN HIDMI MA'ARIF", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.07", "nama": "DARRYLL MARCHIAND MUCHAMMAD NAUVAL I", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.08", "nama": "DEA CANTIKA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.09", "nama": "GALIH VIRGI PRAMUDYA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.10", "nama": "INAYAH CIKAL NURSHABRINA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.11", "nama": "IVAN SIGIT SANTOSO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.12", "nama": "KURNIA ANGGA DIMAS PRATAMA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.13", "nama": "LUKMAN ARIF WICAKSONO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.14", "nama": "MAULIDYA NURUL MUHARROMAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.15", "nama": "MUHAMMAD ARYA BIMA SURYA PRATAMA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.16", "nama": "MUHAMMAD DZAKYY AN NAFI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.17", "nama": "Muhammad Irfan", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.18", "nama": "MUHAMMAD RHAFI HAIRY MUSLIM", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.19", "nama": "MUKHLISH PRATAMA MULYA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.20", "nama": "RAHMA APRILLIANA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.21", "nama": "RASYA PANDU WICAKSONO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.22", "nama": "REVO SETYO KINASIH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.23", "nama": "RIDHO ARSYIL HAKIM", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.24", "nama": "RITA YULIA SARI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.25", "nama": "RIZKY ADITYA WIJAYA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.26", "nama": "VANNISA ALDIRA KIRANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.01", "nama": "AANG KUNADI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.02", "nama": "ALVIAN REZA MAHARDIKA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.03", "nama": "AMANDA CHRISTINA SITUMORANG", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.04", "nama": "AZKA GALUH BASUKI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.05", "nama": "BAGAS IDDEN LISTIYANTO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.06", "nama": "CHEETAH AMRULLAH SWASTIKA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.07", "nama": "DELA FAJAR MULIA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.08", "nama": "EVAN OCTAVIAN RAMADHAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.09", "nama": "HADZIQ VINU MUFIDANY", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.10", "nama": "IRGI AKBAR FAHLEVI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.11", "nama": "JATMIKO SATRIO WIBOWO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.12", "nama": "LAKSAMANA AGUNG HADI NUGROHO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.13", "nama": "MILADIYAH ARINAL HAQ", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.14", "nama": "MUHAMMAD BARUNA SAYLENDRA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.15", "nama": "MUHAMMAD FADHIL", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.16", "nama": "NAUFAL AZKA FADHLILLAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.17", "nama": "NAZIFA CITRA NURVIANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.18", "nama": "NIA SELVIA MAHDALENA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.19", "nama": "REIGZA NASYA PRATITHA RINGGIANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.20", "nama": "RIZKY AKBAR ARDIANSYAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.21", "nama": "SATRIA HATIM MARRENTO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.22", "nama": "THOMAS ANDROMEDA ELANG BUANA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.23", "nama": "ULFAN NAYAKA DIPTA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.24", "nama": "YUSUF RICKY HARTONO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.25", "nama": "ZIYAUL FALAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.01", "nama": "ABIMANYU GILAR WALUYO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.02", "nama": "AHMAD CHOMSIN SYAHFRUDDIN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.03", "nama": "AISY TSABITA AMRU", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.04", "nama": "AKBAR HAKIM MUZAKY", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.05", "nama": "ALFIN ROZZAQ NIRWANA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.06", "nama": "ANISA NURWAHIDAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.07", "nama": "BASITH ANUGRAH YAFI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.08", "nama": "BENAYYA NOHAN ADMIRALDO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.09", "nama": "DANISH MAHDI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.10", "nama": "EGIE AMILIA VELISDIONO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.11", "nama": "FEBY YUANGGI PUTRI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.12", "nama": "HANIF ALBANA ROZAD", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.13", "nama": "INDRA WIJAYA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.14", "nama": "JONATHAN EDWARD SINAGA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.15", "nama": "KATRINA AGNI HARTANTO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.16", "nama": "MUHAMMAD ALMAHDI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.17", "nama": "MUHAMMAD FAISAL REZA MUSTOFA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.18", "nama": "MUHAMMAD RIZKY FADHILA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.19", "nama": "MUHAMMAD SYAUQI ALGHIFARI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.20", "nama": "NABILA RAMADANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.21", "nama": "NANDA ARIFIA CHOERUNISA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.22", "nama": "RAFIF ALI FAHREZI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.23", "nama": "RAKI ABHISTA PRAKOSO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.24", "nama": "SALMA ZAHRA RAMADHANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.25", "nama": "SATRIO ADZI PRIAMBODO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.26", "nama": "VIAN MAULANA RAMADHAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.01", "nama": "ANISA FARCHA NOVIANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.02", "nama": "ARJUNA NATHA PRATISENA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.03", "nama": "ARYODIMAS DZAKI WITRYAWAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.04", "nama": "AZKA BARIQLANA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.05", "nama": "CAHYO GADHANG PUTRO BASKORO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.06", "nama": "CANTIKA ALIFIA MAHARANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.07", "nama": "DEWANGGA RADITYA NUGROHO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.08", "nama": "EIREN WIBI HIDAYAT", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.09", "nama": "GANANG SYAIFULLAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.10", "nama": "HAFIZH IMAN WICAKSONO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.11", "nama": "KENCANA IKHSANUN NADJA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.12", "nama": "KHANSA INTANIA UTOMO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.13", "nama": "MI. AULIA KURNIA WIDYARANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.14", "nama": "MUHAMMAD ASDIF AFADA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.15", "nama": "MUHAMMAD BINTANG SATRIO UTOMO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.16", "nama": "MUHAMMAD ILHAM RIJAL THAARIQ", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.17", "nama": "MUHAMMAD MUMTAZA AL AFKAR", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.18", "nama": "NAJWA RAHMA HAPSARI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.19", "nama": "PANDU SETYA NUGRAHA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.20", "nama": "PUTRI LEVINA AGATHA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.21", "nama": "RAUL HARYO FAUZIAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.22", "nama": "RAY EGANS PRAMUDYA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.23", "nama": "RIKO ADITYA ZAKI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.24", "nama": "SENDI PRASETYO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.25", "nama": "SEPTIA ISNAENI SALSABILA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.26", "nama": "YUSUF FADHLIH FIRMANSYAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.01", "nama": "ABYAN FAZA NARISWANGGA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.02", "nama": "ADILA DIMAZ BUWANA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.03", "nama": "ANNISA NAELIL IZATI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.04", "nama": "BAGASKARA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.05", "nama": "CEZAR NARESWARA RESPATI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.06", "nama": "DEVI IBNU NABILA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.07", "nama": "DIAH DWI ASTUTI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.08", "nama": "DIMAS ADHIE NUGROHO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.10", "nama": "GHUFRON AINUN NAJIB", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.11", "nama": "IZZA BAGHUZ SYAFI'I MA'ARIF", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.12", "nama": "M. OKSA SETYARSO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.13", "nama": "MUHAMMAD HIKMAL ALFARIDZY BACHTIAR", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.14", "nama": "MUHAMMAD IBRAHIM", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.15", "nama": "MUHAMMAD RAFA ENRICO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.16", "nama": "NABILA AZ ZAHRA MUNIR", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.17", "nama": "PAULUS ALE KRISTIAWAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.18", "nama": "RAJABA HAMIM MAUDUDI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.19", "nama": "RIZTIKA MERISTA INDRIANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.20", "nama": "ROIHAN SAPUTRA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.21", "nama": "SITI MIFTAHUS SA'DIYAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.22", "nama": "SRI PUJANGGA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.23", "nama": "TERRA SURYA NEGARI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.24", "nama": "ZALFA AZ ZAHRA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.25", "nama": "ZULFIKRI ARYA PUTRA ISMAIL", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.01", "nama": "ADRIANSYAH ALFARISYI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.02", "nama": "AGUNG HADI ASTANTO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.03", "nama": "AHMAD FARKHANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.04", "nama": "ANINDHA CAHYA MULIA SALIM", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.05", "nama": "ARIF KURNIA RAHMAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.06", "nama": "ATHAYA PANDU MARENO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.07", "nama": "DANIEL ADI PRATAMA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.08", "nama": "DAVIN ALIFIANDA ADYTIA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.09", "nama": "FAJAR DWI FIRMANSYAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.10", "nama": "FITRIANA NAYLA NOVIANTI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.11", "nama": "GILANG MAULANATA PRAMUDYA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.13", "nama": "ILHAM TARUPRASETYO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.14", "nama": "IRMA INNAYAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.15", "nama": "KHILDA SALSABILA AZKA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.16", "nama": "MARVELLINA DEVI WURDHANING", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.17", "nama": "MAULANA FAJAR ROHMANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.18", "nama": "MILA ROSITA DEWI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.19", "nama": "MUHAMAD HAYDAR AYDIN ALHAMDANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.20", "nama": "MUHAMMAD SYAUQI MAULANA ANANSYAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.21", "nama": "MUHAMMAD ZAKIY FADHLULLAH AZHAR", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.22", "nama": "RACHMAD YOGO DWIYANTO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.23", "nama": "RAFI ARTHAYANA PUTRA DERIZMA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.26", "nama": "TUBAGUS PRATAMA JULIANTO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.22.1.25", "nama": "TITO WAHYU PRATAMA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.01", "nama": "AHMAD RIZKIADI BUDI WIRAWAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.02", "nama": "AKSOBHYA SAMATHA VARGA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.03", "nama": "ANINDITA NAJWA EKA SABRINA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.04", "nama": "ATSIILA ARYA NABIIH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.05", "nama": "AZANI FATTUR FADHIKA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.06", "nama": "DANU ALAMSYAH PUTRA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.07", "nama": "FAISHAL ANANDA RACHMAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.08", "nama": "FAJAR WAHYU SURYAPUTRA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.09", "nama": "HANIF ABDUSY SYAKUR", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.10", "nama": "HELSA CHRISTABEL HARSONO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.11", "nama": "IBRAHIM ARYAN FARIDZI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.12", "nama": "IVAN RAKHA ADINATA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.13", "nama": "JONATHAN ORDRICK EDRA WIJAYA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.15", "nama": "MIFTACHUSSURUR", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.16", "nama": "MUHAMAD RIFKI SURYA PRATAMA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.17", "nama": "MUHAMMAD FATWA SYAIKHONI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.18", "nama": "MUHAMMAD RAFIF PASYA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.19", "nama": "NICHOLAS ERNESTO ANAK AGUNG", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.20", "nama": "RAHMALYANA AYUNINGTYAS", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.21", "nama": "RASYAD TANZILUR RAHMAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.22", "nama": "ROHIMATUN NURIN NADHIFAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.23", "nama": "TARISHA NAILA ANGELIN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.24", "nama": "TRISTAN EKA WIRANATA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.25", "nama": "WARSENO BAMBANG SETYONO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.01", "nama": "ADINDA RAHIMAH AZZAHRA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.02", "nama": "ADJIE RADHITYA KUSSENA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.03", "nama": "ADNAN BIMA ADHI NUGRAHA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.04", "nama": "ALDO RAMADHANA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.05", "nama": "AMMAR LUQMAN ARIFIN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.06", "nama": "ANINDITA RAHMA AZALIA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.07", "nama": "AZKA NUR FADEL", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.08", "nama": "BAGUS SADEWA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.09", "nama": "CHALLISTA RISKIANA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.10", "nama": "DIRGA PRIYANTO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.11", "nama": "FAIZ AKMAL NURHAKIM", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.12", "nama": "FATHURRAFI NADIO BUSONO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.13", "nama": "GHAFARI ARIF JABBAR", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.14", "nama": "HASNA RUMAISHA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.15", "nama": "ILHAM AJI IRAWAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.16", "nama": "ILHAM INDRA ATMAJA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.17", "nama": "MUHAMAD ZA'IM SETYAWAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.18", "nama": "MUHAMMAD DZAKY JAMALUDDIN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.19", "nama": "MUHAMMAD HAIDAR ALY", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.20", "nama": "MUHAMMAD IMAM MUSTOFA KAMAL", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.21", "nama": "MUHAMMAD JANUAR RIFQI NANDA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.22", "nama": "MUHAMMAD ROOZIQIN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.23", "nama": "PRABASWARA SHAFA AZARIOMA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.24", "nama": "SAHARDIAN PUTRA WIGUNA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.25", "nama": "SALWA SALSABILA DAFFA'ATULHAQ", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.26", "nama": "ZULVIKAR KHARISMA NUR MUHAMMAD", "error": "Cannot read properties of undefined (reading 'findFirst')"}]	2	2026-05-03 13:18:25.261	\N
8	197501012005011001	1	kompen-mhs-TI-1A.xlsx	226	0	[{"nim": "4.33.25.0.01", "nama": "Aisa Reta Lestari", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.02", "nama": "ANDRIAN AMIRUDIN RAHMANTO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.03", "nama": "ANNISA NUR FARIKHA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.04", "nama": "CHOIRUL RAISSA PASHA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.05", "nama": "CHRISTYAN FABIANO YEHEZKIEL", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.06", "nama": "DASI HAYU PERMANA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.07", "nama": "DIMAS BAYU PRATAMA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.08", "nama": "DZIDAN ADRIAN FIRMANSYAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.09", "nama": "HERDIN SAVIRA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.10", "nama": "IRSYAD ZAKI RAMDHANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.11", "nama": "KAVINDRA VABRIANANDA PUTRA MAHESWARA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.12", "nama": "KYLA CHAVELA EVANGELISTA WANGET", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.13", "nama": "MIKHAEL SURYA ADEPUTRA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.14", "nama": "MOH FAREL AGUSTIN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.15", "nama": "MUHAMMAD FAIQ AUDAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.16", "nama": "MUHAMMAD FAIZ FIRMANSYAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.17", "nama": "MUHAMMAD FAQIH RAMADHAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.18", "nama": "NUR AINI WIDIYANTI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.19", "nama": "PRANAJA LUTHFI BELIAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.20", "nama": "RAFAEL MARCELLO DWI NANDA BORO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.21", "nama": "RASYA NAUFAL HARLIANDRA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.22", "nama": "RIKI ULIR NIAM", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.23", "nama": "SEANIRMA AIDA CANDRAWATI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.24", "nama": "TEGAR BAGUS SATRIA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.25", "nama": "VICTOR ABDIEL KURNIAWAN RARES", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.01", "nama": "AHMAD FAJRIL FALAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.02", "nama": "ALIFANDI AHMAD SURYAWAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.03", "nama": "ANISA AULIA NURUSYIFA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.04", "nama": "ARINDA LUSYANA DEWI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.05", "nama": "BIMO RADYNDRA PRAMASARA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.06", "nama": "DAFFA ARMADHAN HIDMI MA'ARIF", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.07", "nama": "DARRYLL MARCHIAND MUCHAMMAD NAUVAL I", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.08", "nama": "DEA CANTIKA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.09", "nama": "GALIH VIRGI PRAMUDYA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.10", "nama": "INAYAH CIKAL NURSHABRINA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.11", "nama": "IVAN SIGIT SANTOSO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.12", "nama": "KURNIA ANGGA DIMAS PRATAMA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.13", "nama": "LUKMAN ARIF WICAKSONO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.14", "nama": "MAULIDYA NURUL MUHARROMAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.15", "nama": "MUHAMMAD ARYA BIMA SURYA PRATAMA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.16", "nama": "MUHAMMAD DZAKYY AN NAFI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.17", "nama": "Muhammad Irfan", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.18", "nama": "MUHAMMAD RHAFI HAIRY MUSLIM", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.19", "nama": "MUKHLISH PRATAMA MULYA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.20", "nama": "RAHMA APRILLIANA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.21", "nama": "RASYA PANDU WICAKSONO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.22", "nama": "REVO SETYO KINASIH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.23", "nama": "RIDHO ARSYIL HAKIM", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.24", "nama": "RITA YULIA SARI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.25", "nama": "RIZKY ADITYA WIJAYA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.26", "nama": "VANNISA ALDIRA KIRANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.01", "nama": "AANG KUNADI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.02", "nama": "ALVIAN REZA MAHARDIKA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.03", "nama": "AMANDA CHRISTINA SITUMORANG", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.04", "nama": "AZKA GALUH BASUKI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.05", "nama": "BAGAS IDDEN LISTIYANTO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.06", "nama": "CHEETAH AMRULLAH SWASTIKA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.07", "nama": "DELA FAJAR MULIA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.08", "nama": "EVAN OCTAVIAN RAMADHAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.09", "nama": "HADZIQ VINU MUFIDANY", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.10", "nama": "IRGI AKBAR FAHLEVI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.11", "nama": "JATMIKO SATRIO WIBOWO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.12", "nama": "LAKSAMANA AGUNG HADI NUGROHO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.13", "nama": "MILADIYAH ARINAL HAQ", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.14", "nama": "MUHAMMAD BARUNA SAYLENDRA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.15", "nama": "MUHAMMAD FADHIL", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.16", "nama": "NAUFAL AZKA FADHLILLAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.17", "nama": "NAZIFA CITRA NURVIANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.18", "nama": "NIA SELVIA MAHDALENA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.19", "nama": "REIGZA NASYA PRATITHA RINGGIANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.20", "nama": "RIZKY AKBAR ARDIANSYAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.21", "nama": "SATRIA HATIM MARRENTO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.22", "nama": "THOMAS ANDROMEDA ELANG BUANA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.23", "nama": "ULFAN NAYAKA DIPTA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.24", "nama": "YUSUF RICKY HARTONO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.25", "nama": "ZIYAUL FALAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.01", "nama": "ABIMANYU GILAR WALUYO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.02", "nama": "AHMAD CHOMSIN SYAHFRUDDIN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.03", "nama": "AISY TSABITA AMRU", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.04", "nama": "AKBAR HAKIM MUZAKY", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.05", "nama": "ALFIN ROZZAQ NIRWANA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.06", "nama": "ANISA NURWAHIDAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.07", "nama": "BASITH ANUGRAH YAFI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.08", "nama": "BENAYYA NOHAN ADMIRALDO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.09", "nama": "DANISH MAHDI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.10", "nama": "EGIE AMILIA VELISDIONO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.11", "nama": "FEBY YUANGGI PUTRI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.12", "nama": "HANIF ALBANA ROZAD", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.13", "nama": "INDRA WIJAYA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.14", "nama": "JONATHAN EDWARD SINAGA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.15", "nama": "KATRINA AGNI HARTANTO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.16", "nama": "MUHAMMAD ALMAHDI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.17", "nama": "MUHAMMAD FAISAL REZA MUSTOFA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.18", "nama": "MUHAMMAD RIZKY FADHILA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.19", "nama": "MUHAMMAD SYAUQI ALGHIFARI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.20", "nama": "NABILA RAMADANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.21", "nama": "NANDA ARIFIA CHOERUNISA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.22", "nama": "RAFIF ALI FAHREZI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.23", "nama": "RAKI ABHISTA PRAKOSO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.24", "nama": "SALMA ZAHRA RAMADHANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.25", "nama": "SATRIO ADZI PRIAMBODO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.26", "nama": "VIAN MAULANA RAMADHAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.01", "nama": "ANISA FARCHA NOVIANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.02", "nama": "ARJUNA NATHA PRATISENA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.03", "nama": "ARYODIMAS DZAKI WITRYAWAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.04", "nama": "AZKA BARIQLANA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.05", "nama": "CAHYO GADHANG PUTRO BASKORO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.06", "nama": "CANTIKA ALIFIA MAHARANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.07", "nama": "DEWANGGA RADITYA NUGROHO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.08", "nama": "EIREN WIBI HIDAYAT", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.09", "nama": "GANANG SYAIFULLAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.10", "nama": "HAFIZH IMAN WICAKSONO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.11", "nama": "KENCANA IKHSANUN NADJA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.12", "nama": "KHANSA INTANIA UTOMO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.13", "nama": "MI. AULIA KURNIA WIDYARANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.14", "nama": "MUHAMMAD ASDIF AFADA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.15", "nama": "MUHAMMAD BINTANG SATRIO UTOMO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.16", "nama": "MUHAMMAD ILHAM RIJAL THAARIQ", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.17", "nama": "MUHAMMAD MUMTAZA AL AFKAR", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.18", "nama": "NAJWA RAHMA HAPSARI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.19", "nama": "PANDU SETYA NUGRAHA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.20", "nama": "PUTRI LEVINA AGATHA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.21", "nama": "RAUL HARYO FAUZIAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.22", "nama": "RAY EGANS PRAMUDYA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.23", "nama": "RIKO ADITYA ZAKI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.24", "nama": "SENDI PRASETYO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.25", "nama": "SEPTIA ISNAENI SALSABILA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.26", "nama": "YUSUF FADHLIH FIRMANSYAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.01", "nama": "ABYAN FAZA NARISWANGGA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.02", "nama": "ADILA DIMAZ BUWANA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.03", "nama": "ANNISA NAELIL IZATI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.04", "nama": "BAGASKARA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.05", "nama": "CEZAR NARESWARA RESPATI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.06", "nama": "DEVI IBNU NABILA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.07", "nama": "DIAH DWI ASTUTI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.08", "nama": "DIMAS ADHIE NUGROHO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.10", "nama": "GHUFRON AINUN NAJIB", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.11", "nama": "IZZA BAGHUZ SYAFI'I MA'ARIF", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.12", "nama": "M. OKSA SETYARSO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.13", "nama": "MUHAMMAD HIKMAL ALFARIDZY BACHTIAR", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.14", "nama": "MUHAMMAD IBRAHIM", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.15", "nama": "MUHAMMAD RAFA ENRICO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.16", "nama": "NABILA AZ ZAHRA MUNIR", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.17", "nama": "PAULUS ALE KRISTIAWAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.18", "nama": "RAJABA HAMIM MAUDUDI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.19", "nama": "RIZTIKA MERISTA INDRIANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.20", "nama": "ROIHAN SAPUTRA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.21", "nama": "SITI MIFTAHUS SA'DIYAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.22", "nama": "SRI PUJANGGA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.23", "nama": "TERRA SURYA NEGARI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.24", "nama": "ZALFA AZ ZAHRA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.25", "nama": "ZULFIKRI ARYA PUTRA ISMAIL", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.01", "nama": "ADRIANSYAH ALFARISYI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.02", "nama": "AGUNG HADI ASTANTO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.03", "nama": "AHMAD FARKHANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.04", "nama": "ANINDHA CAHYA MULIA SALIM", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.05", "nama": "ARIF KURNIA RAHMAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.06", "nama": "ATHAYA PANDU MARENO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.07", "nama": "DANIEL ADI PRATAMA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.08", "nama": "DAVIN ALIFIANDA ADYTIA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.09", "nama": "FAJAR DWI FIRMANSYAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.10", "nama": "FITRIANA NAYLA NOVIANTI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.11", "nama": "GILANG MAULANATA PRAMUDYA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.13", "nama": "ILHAM TARUPRASETYO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.14", "nama": "IRMA INNAYAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.15", "nama": "KHILDA SALSABILA AZKA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.16", "nama": "MARVELLINA DEVI WURDHANING", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.17", "nama": "MAULANA FAJAR ROHMANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.18", "nama": "MILA ROSITA DEWI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.19", "nama": "MUHAMAD HAYDAR AYDIN ALHAMDANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.20", "nama": "MUHAMMAD SYAUQI MAULANA ANANSYAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.21", "nama": "MUHAMMAD ZAKIY FADHLULLAH AZHAR", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.22", "nama": "RACHMAD YOGO DWIYANTO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.23", "nama": "RAFI ARTHAYANA PUTRA DERIZMA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.26", "nama": "TUBAGUS PRATAMA JULIANTO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.22.1.25", "nama": "TITO WAHYU PRATAMA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.01", "nama": "AHMAD RIZKIADI BUDI WIRAWAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.02", "nama": "AKSOBHYA SAMATHA VARGA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.03", "nama": "ANINDITA NAJWA EKA SABRINA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.04", "nama": "ATSIILA ARYA NABIIH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.05", "nama": "AZANI FATTUR FADHIKA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.06", "nama": "DANU ALAMSYAH PUTRA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.07", "nama": "FAISHAL ANANDA RACHMAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.08", "nama": "FAJAR WAHYU SURYAPUTRA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.09", "nama": "HANIF ABDUSY SYAKUR", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.10", "nama": "HELSA CHRISTABEL HARSONO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.11", "nama": "IBRAHIM ARYAN FARIDZI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.12", "nama": "IVAN RAKHA ADINATA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.13", "nama": "JONATHAN ORDRICK EDRA WIJAYA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.15", "nama": "MIFTACHUSSURUR", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.16", "nama": "MUHAMAD RIFKI SURYA PRATAMA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.17", "nama": "MUHAMMAD FATWA SYAIKHONI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.18", "nama": "MUHAMMAD RAFIF PASYA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.19", "nama": "NICHOLAS ERNESTO ANAK AGUNG", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.20", "nama": "RAHMALYANA AYUNINGTYAS", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.21", "nama": "RASYAD TANZILUR RAHMAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.22", "nama": "ROHIMATUN NURIN NADHIFAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.23", "nama": "TARISHA NAILA ANGELIN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.24", "nama": "TRISTAN EKA WIRANATA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.25", "nama": "WARSENO BAMBANG SETYONO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.01", "nama": "ADINDA RAHIMAH AZZAHRA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.02", "nama": "ADJIE RADHITYA KUSSENA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.03", "nama": "ADNAN BIMA ADHI NUGRAHA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.04", "nama": "ALDO RAMADHANA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.05", "nama": "AMMAR LUQMAN ARIFIN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.06", "nama": "ANINDITA RAHMA AZALIA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.07", "nama": "AZKA NUR FADEL", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.08", "nama": "BAGUS SADEWA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.09", "nama": "CHALLISTA RISKIANA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.10", "nama": "DIRGA PRIYANTO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.11", "nama": "FAIZ AKMAL NURHAKIM", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.12", "nama": "FATHURRAFI NADIO BUSONO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.13", "nama": "GHAFARI ARIF JABBAR", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.14", "nama": "HASNA RUMAISHA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.15", "nama": "ILHAM AJI IRAWAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.16", "nama": "ILHAM INDRA ATMAJA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.17", "nama": "MUHAMAD ZA'IM SETYAWAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.18", "nama": "MUHAMMAD DZAKY JAMALUDDIN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.19", "nama": "MUHAMMAD HAIDAR ALY", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.20", "nama": "MUHAMMAD IMAM MUSTOFA KAMAL", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.21", "nama": "MUHAMMAD JANUAR RIFQI NANDA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.22", "nama": "MUHAMMAD ROOZIQIN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.23", "nama": "PRABASWARA SHAFA AZARIOMA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.24", "nama": "SAHARDIAN PUTRA WIGUNA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.25", "nama": "SALWA SALSABILA DAFFA'ATULHAQ", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.26", "nama": "ZULVIKAR KHARISMA NUR MUHAMMAD", "error": "Cannot read properties of undefined (reading 'findFirst')"}]	2	2026-05-03 13:32:00.246	\N
14	STAF001	1	kompen-mhs-TI-1A.xlsx	226	226	null	1	2026-05-26 06:16:43.832	c0881499d66830c0aa80db5cefc0b98d951a80bc92f0148db0585f9c74a878ae
\.


--
-- TOC entry 4443 (class 0 OID 17574)
-- Dependencies: 356
-- Data for Name: jurusan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.jurusan (id, nama_jurusan) FROM stdin;
1	Fakultas Teknik
2	Fakultas Ekonomi
3	Fakultas Ilmu Komputer
4	Fakultas Hukum
\.


--
-- TOC entry 4445 (class 0 OID 17580)
-- Dependencies: 358
-- Data for Name: kelas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kelas (id, prodi_id, nama_kelas) FROM stdin;
1	1	IF-1A
8	3	TE-1
9	4	TM-1
10	5	MN-1A
11	5	MN-1B
12	6	AK-1
13	8	IK-1
14	8	IK-2
15	9	SI-1
16	\N	TI-1A
17	\N	TI-1B
18	\N	TI-1C
19	\N	TI-2A
20	\N	TI-2B
21	\N	TI-2C
22	\N	TI-3A
23	\N	TI-3B
24	\N	TI-3C
\.


--
-- TOC entry 4447 (class 0 OID 17586)
-- Dependencies: 360
-- Data for Name: kompen_awal; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kompen_awal (id, nim, semester_id, import_id, total_jam_wajib, created_at) FROM stdin;
2	220101002	1	2	30	2024-08-21 10:30:00
3	220101003	1	2	30	2024-08-21 10:30:00
4	220101004	1	2	30	2024-08-21 10:30:00
5	220101005	1	2	30	2024-08-21 10:30:00
6	220102001	1	2	30	2024-08-21 10:30:00
7	220102002	1	2	30	2024-08-21 10:30:00
8	220103001	1	2	30	2024-08-21 10:30:00
9	220104001	1	2	30	2024-08-21 10:30:00
10	220105001	1	2	30	2024-08-21 10:30:00
11	220105002	1	2	30	2024-08-21 10:30:00
12	220105003	1	2	30	2024-08-21 10:30:00
13	210101001	1	2	25	2024-08-21 10:30:00
14	210101002	1	2	25	2024-08-21 10:30:00
15	220106001	1	2	30	2024-08-21 10:30:00
16	220101001	2	4	30	2024-01-11 09:00:00
17	220101002	2	4	30	2024-01-11 09:00:00
18	220101003	2	4	30	2024-01-11 09:00:00
19	220105001	3	5	25	2023-08-16 09:00:00
25	4.33.25.0.06	1	14	40	2026-05-03 13:34:11.195
26	4.33.25.0.07	1	14	0	2026-05-03 13:34:11.228
27	4.33.25.0.08	1	14	0	2026-05-03 13:34:11.259
28	4.33.25.0.09	1	14	0	2026-05-03 13:34:11.292
29	4.33.25.0.10	1	14	0	2026-05-03 13:34:11.328
31	4.33.25.0.12	1	14	0	2026-05-03 13:34:11.392
32	4.33.25.0.13	1	14	0	2026-05-03 13:34:11.424
33	4.33.25.0.14	1	14	0	2026-05-03 13:34:11.459
34	4.33.25.0.15	1	14	0	2026-05-03 13:34:11.491
35	4.33.25.0.16	1	14	0	2026-05-03 13:34:11.518
36	4.33.25.0.17	1	14	0	2026-05-03 13:34:11.549
37	4.33.25.0.18	1	14	0	2026-05-03 13:34:11.586
38	4.33.25.0.19	1	14	0	2026-05-03 13:34:11.63
39	4.33.25.0.20	1	14	0	2026-05-03 13:34:11.664
40	4.33.25.0.21	1	14	456	2026-05-03 13:34:11.691
41	4.33.25.0.22	1	14	0	2026-05-03 13:34:11.748
42	4.33.25.0.23	1	14	0	2026-05-03 13:34:11.777
43	4.33.25.0.24	1	14	0	2026-05-03 13:34:11.815
44	4.33.25.0.25	1	14	0	2026-05-03 13:34:11.848
45	4.33.25.1.01	1	14	0	2026-05-03 13:34:11.881
46	4.33.25.1.02	1	14	0	2026-05-03 13:34:11.92
47	4.33.25.1.03	1	14	0	2026-05-03 13:34:11.956
48	4.33.25.1.04	1	14	0	2026-05-03 13:34:11.988
50	4.33.25.1.06	1	14	0	2026-05-03 13:34:12.072
51	4.33.25.1.07	1	14	0	2026-05-03 13:34:12.127
52	4.33.25.1.08	1	14	0	2026-05-03 13:34:12.167
53	4.33.25.1.09	1	14	0	2026-05-03 13:34:12.202
54	4.33.25.1.10	1	14	0	2026-05-03 13:34:12.236
55	4.33.25.1.11	1	14	0	2026-05-03 13:34:12.262
56	4.33.25.1.12	1	14	0	2026-05-03 13:34:12.29
57	4.33.25.1.13	1	14	0	2026-05-03 13:34:12.319
58	4.33.25.1.14	1	14	0	2026-05-03 13:34:12.35
59	4.33.25.1.15	1	14	0	2026-05-03 13:34:12.38
60	4.33.25.1.16	1	14	0	2026-05-03 13:34:12.42
61	4.33.25.1.17	1	14	0	2026-05-03 13:34:12.453
62	4.33.25.1.18	1	14	0	2026-05-03 13:34:12.518
63	4.33.25.1.19	1	14	0	2026-05-03 13:34:12.557
64	4.33.25.1.20	1	14	0	2026-05-03 13:34:12.591
65	4.33.25.1.21	1	14	0	2026-05-03 13:34:12.64
66	4.33.25.1.22	1	14	0	2026-05-03 13:34:12.683
67	4.33.25.1.23	1	14	0	2026-05-03 13:34:12.723
69	4.33.25.1.25	1	14	0	2026-05-03 13:34:12.795
70	4.33.25.1.26	1	14	0	2026-05-03 13:34:12.829
71	4.33.25.2.01	1	14	96	2026-05-03 13:34:12.858
72	4.33.25.2.02	1	14	0	2026-05-03 13:34:12.886
73	4.33.25.2.03	1	14	0	2026-05-03 13:34:12.921
74	4.33.25.2.04	1	14	24	2026-05-03 13:34:12.954
75	4.33.25.2.05	1	14	0	2026-05-03 13:34:12.992
76	4.33.25.2.06	1	14	0	2026-05-03 13:34:13.044
77	4.33.25.2.07	1	14	0	2026-05-03 13:34:13.12
78	4.33.25.2.08	1	14	0	2026-05-03 13:34:13.173
79	4.33.25.2.09	1	14	0	2026-05-03 13:34:13.207
80	4.33.25.2.10	1	14	16	2026-05-03 13:34:13.24
81	4.33.25.2.11	1	14	0	2026-05-03 13:34:13.274
82	4.33.25.2.12	1	14	8	2026-05-03 13:34:13.307
83	4.33.25.2.13	1	14	0	2026-05-03 13:34:13.345
84	4.33.25.2.14	1	14	0	2026-05-03 13:34:13.364
85	4.33.25.2.15	1	14	0	2026-05-03 13:34:13.387
86	4.33.25.2.16	1	14	0	2026-05-03 13:34:13.417
88	4.33.25.2.18	1	14	0	2026-05-03 13:34:13.491
89	4.33.25.2.19	1	14	0	2026-05-03 13:34:13.521
90	4.33.25.2.20	1	14	96	2026-05-03 13:34:13.572
91	4.33.25.2.21	1	14	0	2026-05-03 13:34:13.604
92	4.33.25.2.22	1	14	0	2026-05-03 13:34:13.633
93	4.33.25.2.23	1	14	8	2026-05-03 13:34:13.662
94	4.33.25.2.24	1	14	0	2026-05-03 13:34:13.694
95	4.33.25.2.25	1	14	0	2026-05-03 13:34:13.731
96	4.33.24.0.01	1	14	32	2026-05-03 13:34:13.772
97	4.33.24.0.02	1	14	0	2026-05-03 13:34:13.811
98	4.33.24.0.03	1	14	0	2026-05-03 13:34:13.843
99	4.33.24.0.04	1	14	0	2026-05-03 13:34:13.876
100	4.33.24.0.05	1	14	0	2026-05-03 13:34:13.926
101	4.33.24.0.06	1	14	776	2026-05-03 13:34:13.954
102	4.33.24.0.07	1	14	0	2026-05-03 13:34:13.982
103	4.33.24.0.08	1	14	0	2026-05-03 13:34:14.015
104	4.33.24.0.09	1	14	0	2026-05-03 13:34:14.045
105	4.33.24.0.10	1	14	0	2026-05-03 13:34:14.072
107	4.33.24.0.12	1	14	0	2026-05-03 13:34:14.128
108	4.33.24.0.13	1	14	0	2026-05-03 13:34:14.156
109	4.33.24.0.14	1	14	0	2026-05-03 13:34:14.185
21	4.33.25.0.02	1	14	0	2026-05-03 13:34:11.051
22	4.33.25.0.03	1	14	0	2026-05-03 13:34:11.089
23	4.33.25.0.04	1	14	0	2026-05-03 13:34:11.121
24	4.33.25.0.05	1	14	0	2026-05-03 13:34:11.159
1	2372001	1	2	28	2024-08-21 10:30:00
115	4.33.24.0.20	1	14	0	2026-05-03 13:34:14.374
116	4.33.24.0.21	1	14	0	2026-05-03 13:34:14.4
117	4.33.24.0.22	1	14	0	2026-05-03 13:34:14.428
118	4.33.24.0.23	1	14	0	2026-05-03 13:34:14.457
119	4.33.24.0.24	1	14	0	2026-05-03 13:34:14.49
121	4.33.24.0.26	1	14	0	2026-05-03 13:34:14.548
122	4.33.24.1.01	1	14	0	2026-05-03 13:34:14.577
123	4.33.24.1.02	1	14	0	2026-05-03 13:34:14.612
124	4.33.24.1.03	1	14	0	2026-05-03 13:34:14.644
125	4.33.24.1.04	1	14	0	2026-05-03 13:34:14.672
126	4.33.24.1.05	1	14	0	2026-05-03 13:34:14.7
127	4.33.24.1.06	1	14	0	2026-05-03 13:34:14.734
128	4.33.24.1.07	1	14	40	2026-05-03 13:34:14.762
129	4.33.24.1.08	1	14	8	2026-05-03 13:34:14.786
130	4.33.24.1.09	1	14	0	2026-05-03 13:34:14.813
131	4.33.24.1.10	1	14	0	2026-05-03 13:34:14.838
132	4.33.24.1.11	1	14	0	2026-05-03 13:34:14.866
133	4.33.24.1.12	1	14	0	2026-05-03 13:34:14.895
134	4.33.24.1.13	1	14	8	2026-05-03 13:34:14.93
135	4.33.24.1.14	1	14	0	2026-05-03 13:34:14.961
136	4.33.24.1.15	1	14	0	2026-05-03 13:34:14.986
137	4.33.24.1.16	1	14	0	2026-05-03 13:34:15.014
138	4.33.24.1.17	1	14	0	2026-05-03 13:34:15.037
140	4.33.24.1.19	1	14	0	2026-05-03 13:34:15.097
141	4.33.24.1.20	1	14	0	2026-05-03 13:34:15.121
142	4.33.24.1.21	1	14	0	2026-05-03 13:34:15.142
143	4.33.24.1.22	1	14	0	2026-05-03 13:34:15.161
144	4.33.24.1.23	1	14	0	2026-05-03 13:34:15.185
145	4.33.24.1.24	1	14	0	2026-05-03 13:34:15.209
146	4.33.24.1.25	1	14	0	2026-05-03 13:34:15.235
147	4.33.24.1.26	1	14	0	2026-05-03 13:34:15.262
148	4.33.24.2.01	1	14	0	2026-05-03 13:34:15.283
149	4.33.24.2.02	1	14	0	2026-05-03 13:34:15.305
150	4.33.24.2.03	1	14	0	2026-05-03 13:34:15.325
151	4.33.24.2.04	1	14	0	2026-05-03 13:34:15.345
152	4.33.24.2.05	1	14	0	2026-05-03 13:34:15.366
153	4.33.24.2.06	1	14	0	2026-05-03 13:34:15.396
154	4.33.24.2.07	1	14	0	2026-05-03 13:34:15.437
155	4.33.24.2.08	1	14	0	2026-05-03 13:34:15.45
156	4.33.24.2.10	1	14	0	2026-05-03 13:34:15.461
157	4.33.24.2.11	1	14	0	2026-05-03 13:34:15.48
159	4.33.24.2.13	1	14	0	2026-05-03 13:34:15.508
160	4.33.24.2.14	1	14	0	2026-05-03 13:34:15.522
161	4.33.24.2.15	1	14	0	2026-05-03 13:34:15.535
162	4.33.24.2.16	1	14	0	2026-05-03 13:34:15.548
163	4.33.24.2.17	1	14	24	2026-05-03 13:34:15.558
164	4.33.24.2.18	1	14	0	2026-05-03 13:34:15.569
165	4.33.24.2.19	1	14	0	2026-05-03 13:34:15.585
166	4.33.24.2.20	1	14	24	2026-05-03 13:34:15.595
167	4.33.24.2.21	1	14	0	2026-05-03 13:34:15.605
168	4.33.24.2.22	1	14	24	2026-05-03 13:34:15.615
169	4.33.24.2.23	1	14	16	2026-05-03 13:34:15.626
170	4.33.24.2.24	1	14	0	2026-05-03 13:34:15.636
171	4.33.24.2.25	1	14	16	2026-05-03 13:34:15.645
172	4.33.23.0.01	1	14	8	2026-05-03 13:34:15.654
173	4.33.23.0.02	1	14	0	2026-05-03 13:34:15.665
174	4.33.23.0.03	1	14	24	2026-05-03 13:34:15.674
175	4.33.23.0.04	1	14	0	2026-05-03 13:34:15.684
176	4.33.23.0.05	1	14	0	2026-05-03 13:34:15.694
178	4.33.23.0.07	1	14	0	2026-05-03 13:34:15.711
179	4.33.23.0.08	1	14	0	2026-05-03 13:34:15.721
180	4.33.23.0.09	1	14	0	2026-05-03 13:34:15.729
181	4.33.23.0.10	1	14	0	2026-05-03 13:34:15.736
182	4.33.23.0.11	1	14	16	2026-05-03 13:34:15.743
183	4.33.23.0.13	1	14	0	2026-05-03 13:34:15.752
184	4.33.23.0.14	1	14	0	2026-05-03 13:34:15.76
185	4.33.23.0.15	1	14	0	2026-05-03 13:34:15.768
186	4.33.23.0.16	1	14	0	2026-05-03 13:34:15.773
187	4.33.23.0.17	1	14	40	2026-05-03 13:34:15.778
188	4.33.23.0.18	1	14	24	2026-05-03 13:34:15.783
189	4.33.23.0.19	1	14	0	2026-05-03 13:34:15.787
190	4.33.23.0.20	1	14	0	2026-05-03 13:34:15.795
191	4.33.23.0.21	1	14	0	2026-05-03 13:34:15.8
192	4.33.23.0.22	1	14	0	2026-05-03 13:34:15.804
193	4.33.23.0.23	1	14	0	2026-05-03 13:34:15.807
194	4.33.23.0.26	1	14	8	2026-05-03 13:34:15.81
195	4.33.22.1.25	1	14	80	2026-05-03 13:34:15.815
197	4.33.23.1.02	1	14	0	2026-05-03 13:34:15.822
198	4.33.23.1.03	1	14	0	2026-05-03 13:34:15.825
199	4.33.23.1.04	1	14	0	2026-05-03 13:34:15.829
200	4.33.23.1.05	1	14	0	2026-05-03 13:34:15.833
201	4.33.23.1.06	1	14	0	2026-05-03 13:34:15.837
202	4.33.23.1.07	1	14	0	2026-05-03 13:34:15.84
203	4.33.23.1.08	1	14	0	2026-05-03 13:34:15.844
204	4.33.23.1.09	1	14	0	2026-05-03 13:34:15.849
205	4.33.23.1.10	1	14	0	2026-05-03 13:34:15.853
206	4.33.23.1.11	1	14	0	2026-05-03 13:34:15.857
207	4.33.23.1.12	1	14	0	2026-05-03 13:34:15.86
208	4.33.23.1.13	1	14	0	2026-05-03 13:34:15.865
209	4.33.23.1.15	1	14	0	2026-05-03 13:34:15.869
210	4.33.23.1.16	1	14	40	2026-05-03 13:34:15.872
211	4.33.23.1.17	1	14	32	2026-05-03 13:34:15.876
212	4.33.23.1.18	1	14	0	2026-05-03 13:34:15.881
213	4.33.23.1.19	1	14	0	2026-05-03 13:34:15.884
214	4.33.23.1.20	1	14	0	2026-05-03 13:34:15.888
216	4.33.23.1.22	1	14	0	2026-05-03 13:34:15.898
111	4.33.24.0.16	1	14	0	2026-05-03 13:34:14.244
112	4.33.24.0.17	1	14	0	2026-05-03 13:34:14.276
113	4.33.24.0.18	1	14	0	2026-05-03 13:34:14.301
114	4.33.24.0.19	1	14	0	2026-05-03 13:34:14.331
110	4.33.24.0.15	1	14	0	2026-05-03 13:34:14.214
120	4.33.24.0.25	1	14	0	2026-05-03 13:34:14.518
139	4.33.24.1.18	1	14	0	2026-05-03 13:34:15.059
158	4.33.24.2.12	1	14	0	2026-05-03 13:34:15.49
177	4.33.23.0.06	1	14	8	2026-05-03 13:34:15.703
196	4.33.23.1.01	1	14	0	2026-05-03 13:34:15.819
215	4.33.23.1.21	1	14	0	2026-05-03 13:34:15.891
217	4.33.23.1.23	1	14	0	2026-05-03 13:34:15.901
218	4.33.23.1.24	1	14	16	2026-05-03 13:34:15.905
219	4.33.23.1.25	1	14	0	2026-05-03 13:34:15.909
220	4.33.23.2.01	1	14	0	2026-05-03 13:34:15.913
221	4.33.23.2.02	1	14	56	2026-05-03 13:34:15.918
222	4.33.23.2.03	1	14	8	2026-05-03 13:34:15.922
20	4.33.25.0.01	1	14	0	2026-05-03 13:34:11.011
30	4.33.25.0.11	1	14	0	2026-05-03 13:34:11.359
49	4.33.25.1.05	1	14	8	2026-05-03 13:34:12.029
68	4.33.25.1.24	1	14	8	2026-05-03 13:34:12.763
87	4.33.25.2.17	1	14	0	2026-05-03 13:34:13.455
106	4.33.24.0.11	1	14	0	2026-05-03 13:34:14.098
223	4.33.23.2.04	1	14	0	2026-05-03 13:34:15.925
224	4.33.23.2.05	1	14	0	2026-05-03 13:34:15.93
225	4.33.23.2.06	1	14	0	2026-05-03 13:34:15.935
226	4.33.23.2.07	1	14	40	2026-05-03 13:34:15.939
227	4.33.23.2.08	1	14	0	2026-05-03 13:34:15.943
228	4.33.23.2.09	1	14	0	2026-05-03 13:34:15.949
229	4.33.23.2.10	1	14	72	2026-05-03 13:34:15.957
230	4.33.23.2.11	1	14	40	2026-05-03 13:34:15.965
231	4.33.23.2.12	1	14	0	2026-05-03 13:34:15.971
232	4.33.23.2.13	1	14	16	2026-05-03 13:34:15.976
233	4.33.23.2.14	1	14	0	2026-05-03 13:34:15.982
234	4.33.23.2.15	1	14	0	2026-05-03 13:34:15.987
235	4.33.23.2.16	1	14	16	2026-05-03 13:34:15.992
236	4.33.23.2.17	1	14	0	2026-05-03 13:34:15.997
237	4.33.23.2.18	1	14	0	2026-05-03 13:34:16.002
238	4.33.23.2.19	1	14	0	2026-05-03 13:34:16.007
239	4.33.23.2.20	1	14	32	2026-05-03 13:34:16.011
240	4.33.23.2.21	1	14	0	2026-05-03 13:34:16.018
241	4.33.23.2.22	1	14	40	2026-05-03 13:34:16.026
242	4.33.23.2.23	1	14	32	2026-05-03 13:34:16.033
243	4.33.23.2.24	1	14	72	2026-05-03 13:34:16.042
244	4.33.23.2.25	1	14	0	2026-05-03 13:34:16.05
245	4.33.23.2.26	1	14	40	2026-05-03 13:34:16.055
\.


--
-- TOC entry 4449 (class 0 OID 17593)
-- Dependencies: 362
-- Data for Name: log_potong_jam; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.log_potong_jam (id, nim, semester_id, penugasan_id, ekuivalensi_id, jam_dikurangi, keterangan, created_at, updated_at) FROM stdin;
24	4.33.25.0.02	1	\N	24	20.67	Ekuivalensi kelas TI-1A	2026-05-31 10:27:50.112	\N
25	4.33.25.0.03	1	\N	24	20.67	Ekuivalensi kelas TI-1A	2026-05-31 10:27:50.112	\N
26	4.33.25.0.04	1	\N	24	20.67	Ekuivalensi kelas TI-1A	2026-05-31 10:27:50.112	\N
27	4.33.25.0.05	1	\N	24	20.67	Ekuivalensi kelas TI-1A	2026-05-31 10:27:50.112	\N
28	4.33.25.0.06	1	\N	24	20.67	Ekuivalensi kelas TI-1A	2026-05-31 10:27:50.112	\N
29	4.33.25.0.07	1	\N	24	20.67	Ekuivalensi kelas TI-1A	2026-05-31 10:27:50.112	\N
30	4.33.25.0.08	1	\N	24	20.67	Ekuivalensi kelas TI-1A	2026-05-31 10:27:50.112	\N
31	4.33.25.0.09	1	\N	24	20.67	Ekuivalensi kelas TI-1A	2026-05-31 10:27:50.112	\N
32	4.33.25.0.10	1	\N	24	20.67	Ekuivalensi kelas TI-1A	2026-05-31 10:27:50.112	\N
33	4.33.25.0.11	1	\N	24	20.67	Ekuivalensi kelas TI-1A	2026-05-31 10:27:50.112	\N
34	4.33.25.0.12	1	\N	24	20.67	Ekuivalensi kelas TI-1A	2026-05-31 10:27:50.112	\N
35	4.33.25.0.13	1	\N	24	20.67	Ekuivalensi kelas TI-1A	2026-05-31 10:27:50.112	\N
36	4.33.25.0.14	1	\N	24	20.67	Ekuivalensi kelas TI-1A	2026-05-31 10:27:50.112	\N
37	4.33.25.0.15	1	\N	24	20.67	Ekuivalensi kelas TI-1A	2026-05-31 10:27:50.112	\N
38	4.33.25.0.16	1	\N	24	20.67	Ekuivalensi kelas TI-1A	2026-05-31 10:27:50.112	\N
39	4.33.25.0.17	1	\N	24	20.67	Ekuivalensi kelas TI-1A	2026-05-31 10:27:50.112	\N
40	4.33.25.0.18	1	\N	24	20.67	Ekuivalensi kelas TI-1A	2026-05-31 10:27:50.112	\N
41	4.33.25.0.19	1	\N	24	20.67	Ekuivalensi kelas TI-1A	2026-05-31 10:27:50.112	\N
42	4.33.25.0.20	1	\N	24	20.67	Ekuivalensi kelas TI-1A	2026-05-31 10:27:50.112	\N
43	4.33.25.0.21	1	\N	24	20.67	Ekuivalensi kelas TI-1A	2026-05-31 10:27:50.112	\N
44	4.33.25.0.22	1	\N	24	20.67	Ekuivalensi kelas TI-1A	2026-05-31 10:27:50.112	\N
45	4.33.25.0.23	1	\N	24	20.67	Ekuivalensi kelas TI-1A	2026-05-31 10:27:50.112	\N
46	4.33.25.0.24	1	\N	24	20.67	Ekuivalensi kelas TI-1A	2026-05-31 10:27:50.112	\N
47	4.33.25.0.25	1	\N	24	20.67	Ekuivalensi kelas TI-1A	2026-05-31 10:27:50.112	\N
48	4.33.24.2.17	1	52	\N	1	Potong jam kompen dari verifikasi penugasan	2026-06-11 05:17:47.117	\N
49	4.33.24.2.01	1	\N	28	4.33	Ekuivalensi kelas TI-2C	2026-06-11 05:23:24.743	\N
50	4.33.24.2.02	1	\N	28	4.33	Ekuivalensi kelas TI-2C	2026-06-11 05:23:24.743	\N
51	4.33.24.2.03	1	\N	28	4.33	Ekuivalensi kelas TI-2C	2026-06-11 05:23:24.743	\N
52	4.33.24.2.04	1	\N	28	4.33	Ekuivalensi kelas TI-2C	2026-06-11 05:23:24.743	\N
53	4.33.24.2.05	1	\N	28	4.33	Ekuivalensi kelas TI-2C	2026-06-11 05:23:24.743	\N
54	4.33.24.2.06	1	\N	28	4.33	Ekuivalensi kelas TI-2C	2026-06-11 05:23:24.743	\N
55	4.33.24.2.07	1	\N	28	4.33	Ekuivalensi kelas TI-2C	2026-06-11 05:23:24.743	\N
56	4.33.24.2.08	1	\N	28	4.33	Ekuivalensi kelas TI-2C	2026-06-11 05:23:24.743	\N
57	4.33.24.2.10	1	\N	28	4.33	Ekuivalensi kelas TI-2C	2026-06-11 05:23:24.743	\N
58	4.33.24.2.11	1	\N	28	4.33	Ekuivalensi kelas TI-2C	2026-06-11 05:23:24.743	\N
59	4.33.24.2.12	1	\N	28	4.33	Ekuivalensi kelas TI-2C	2026-06-11 05:23:24.743	\N
60	4.33.24.2.13	1	\N	28	4.33	Ekuivalensi kelas TI-2C	2026-06-11 05:23:24.743	\N
61	4.33.24.2.14	1	\N	28	4.33	Ekuivalensi kelas TI-2C	2026-06-11 05:23:24.743	\N
62	4.33.24.2.15	1	\N	28	4.33	Ekuivalensi kelas TI-2C	2026-06-11 05:23:24.743	\N
63	4.33.24.2.16	1	\N	28	4.33	Ekuivalensi kelas TI-2C	2026-06-11 05:23:24.743	\N
64	4.33.24.2.17	1	\N	28	4.33	Ekuivalensi kelas TI-2C	2026-06-11 05:23:24.743	\N
65	4.33.24.2.18	1	\N	28	4.33	Ekuivalensi kelas TI-2C	2026-06-11 05:23:24.743	\N
66	4.33.24.2.19	1	\N	28	4.33	Ekuivalensi kelas TI-2C	2026-06-11 05:23:24.743	\N
67	4.33.24.2.20	1	\N	28	4.33	Ekuivalensi kelas TI-2C	2026-06-11 05:23:24.743	\N
68	4.33.24.2.21	1	\N	28	4.33	Ekuivalensi kelas TI-2C	2026-06-11 05:23:24.743	\N
69	4.33.24.2.22	1	\N	28	4.33	Ekuivalensi kelas TI-2C	2026-06-11 05:23:24.743	\N
70	4.33.24.2.23	1	\N	28	4.33	Ekuivalensi kelas TI-2C	2026-06-11 05:23:24.743	\N
71	4.33.24.2.24	1	\N	28	4.33	Ekuivalensi kelas TI-2C	2026-06-11 05:23:24.743	\N
72	4.33.24.2.25	1	\N	28	4.33	Ekuivalensi kelas TI-2C	2026-06-11 05:23:24.743	\N
\.


--
-- TOC entry 4451 (class 0 OID 17600)
-- Dependencies: 364
-- Data for Name: mahasiswa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mahasiswa (nim, user_id, nama) FROM stdin;
220101001	7	Andi Pratama
220101002	8	Budi Wibowo
220101003	9	Citra Dewi
220101004	10	Dian Sastro
220101005	11	Eko Prasetyo
220102001	\N	Fajar Nugroho
220102002	\N	Gita Rahayu
220103001	\N	Hendra Setiawan
220104001	\N	Indah Permata
220105001	\N	Joko Susilo
220105002	\N	Kartika Sari
220105003	\N	Lukman Hakim
210101001	\N	Mega Lestari
210101002	\N	Nanda Putri
220106001	\N	Oscar Simanjuntak
2372001	12	Akbar Testing
4.33.25.0.01	239	Aisa Reta Lestari
4.33.25.0.02	240	ANDRIAN AMIRUDIN RAHMANTO
4.33.25.0.03	241	ANNISA NUR FARIKHA
4.33.25.0.04	242	CHOIRUL RAISSA PASHA
4.33.25.0.05	243	CHRISTYAN FABIANO YEHEZKIEL
4.33.25.0.06	244	DASI HAYU PERMANA
4.33.25.0.07	245	DIMAS BAYU PRATAMA
4.33.25.0.08	246	DZIDAN ADRIAN FIRMANSYAH
4.33.25.0.09	247	HERDIN SAVIRA
4.33.25.0.10	248	IRSYAD ZAKI RAMDHANI
4.33.25.0.11	249	KAVINDRA VABRIANANDA PUTRA MAHESWARA
4.33.25.0.12	250	KYLA CHAVELA EVANGELISTA WANGET
4.33.25.0.13	251	MIKHAEL SURYA ADEPUTRA
4.33.25.0.14	252	MOH FAREL AGUSTIN
4.33.25.0.15	253	MUHAMMAD FAIQ AUDAH
4.33.25.0.16	254	MUHAMMAD FAIZ FIRMANSYAH
4.33.25.0.17	255	MUHAMMAD FAQIH RAMADHAN
4.33.25.0.18	256	NUR AINI WIDIYANTI
4.33.25.0.19	257	PRANAJA LUTHFI BELIAN
4.33.25.0.20	258	RAFAEL MARCELLO DWI NANDA BORO
4.33.25.0.21	259	RASYA NAUFAL HARLIANDRA
4.33.25.0.22	260	RIKI ULIR NIAM
4.33.25.0.23	261	SEANIRMA AIDA CANDRAWATI
4.33.25.0.24	262	TEGAR BAGUS SATRIA
4.33.25.0.25	263	VICTOR ABDIEL KURNIAWAN RARES
4.33.25.1.01	264	AHMAD FAJRIL FALAH
4.33.25.1.02	265	ALIFANDI AHMAD SURYAWAN
4.33.25.1.03	266	ANISA AULIA NURUSYIFA
4.33.25.1.04	267	ARINDA LUSYANA DEWI
4.33.25.1.05	268	BIMO RADYNDRA PRAMASARA
4.33.25.1.06	269	DAFFA ARMADHAN HIDMI MA'ARIF
4.33.25.1.07	270	DARRYLL MARCHIAND MUCHAMMAD NAUVAL I
4.33.25.1.08	271	DEA CANTIKA
4.33.25.1.09	272	GALIH VIRGI PRAMUDYA
4.33.25.1.10	273	INAYAH CIKAL NURSHABRINA
4.33.25.1.11	274	IVAN SIGIT SANTOSO
4.33.25.1.12	275	KURNIA ANGGA DIMAS PRATAMA
4.33.25.1.13	276	LUKMAN ARIF WICAKSONO
4.33.25.1.14	277	MAULIDYA NURUL MUHARROMAH
4.33.25.1.15	278	MUHAMMAD ARYA BIMA SURYA PRATAMA
4.33.25.1.16	279	MUHAMMAD DZAKYY AN NAFI
4.33.25.1.17	280	Muhammad Irfan
4.33.25.1.18	281	MUHAMMAD RHAFI HAIRY MUSLIM
4.33.25.1.19	282	MUKHLISH PRATAMA MULYA
4.33.25.1.20	283	RAHMA APRILLIANA
4.33.25.1.21	284	RASYA PANDU WICAKSONO
4.33.25.1.22	285	REVO SETYO KINASIH
4.33.25.1.23	286	RIDHO ARSYIL HAKIM
4.33.25.1.24	287	RITA YULIA SARI
4.33.25.1.25	288	RIZKY ADITYA WIJAYA
4.33.25.1.26	289	VANNISA ALDIRA KIRANI
4.33.25.2.01	290	AANG KUNADI
4.33.25.2.02	291	ALVIAN REZA MAHARDIKA
4.33.25.2.03	292	AMANDA CHRISTINA SITUMORANG
4.33.25.2.04	293	AZKA GALUH BASUKI
4.33.25.2.05	294	BAGAS IDDEN LISTIYANTO
4.33.25.2.06	295	CHEETAH AMRULLAH SWASTIKA
4.33.25.2.07	296	DELA FAJAR MULIA
4.33.25.2.08	297	EVAN OCTAVIAN RAMADHAN
4.33.25.2.09	298	HADZIQ VINU MUFIDANY
4.33.25.2.10	299	IRGI AKBAR FAHLEVI
4.33.25.2.11	300	JATMIKO SATRIO WIBOWO
4.33.25.2.12	301	LAKSAMANA AGUNG HADI NUGROHO
4.33.25.2.13	302	MILADIYAH ARINAL HAQ
4.33.25.2.14	303	MUHAMMAD BARUNA SAYLENDRA
4.33.25.2.15	304	MUHAMMAD FADHIL
4.33.25.2.16	305	NAUFAL AZKA FADHLILLAH
4.33.25.2.17	306	NAZIFA CITRA NURVIANI
4.33.25.2.18	307	NIA SELVIA MAHDALENA
4.33.25.2.19	308	REIGZA NASYA PRATITHA RINGGIANI
4.33.25.2.20	309	RIZKY AKBAR ARDIANSYAH
4.33.25.2.21	310	SATRIA HATIM MARRENTO
4.33.25.2.22	311	THOMAS ANDROMEDA ELANG BUANA
4.33.25.2.23	312	ULFAN NAYAKA DIPTA
4.33.25.2.24	313	YUSUF RICKY HARTONO
4.33.25.2.25	314	ZIYAUL FALAH
4.33.24.0.01	315	ABIMANYU GILAR WALUYO
4.33.24.0.02	316	AHMAD CHOMSIN SYAHFRUDDIN
4.33.24.0.03	317	AISY TSABITA AMRU
4.33.24.0.04	318	AKBAR HAKIM MUZAKY
4.33.24.0.05	319	ALFIN ROZZAQ NIRWANA
4.33.24.0.06	320	ANISA NURWAHIDAH
4.33.24.0.07	321	BASITH ANUGRAH YAFI
4.33.24.0.08	322	BENAYYA NOHAN ADMIRALDO
4.33.24.0.09	323	DANISH MAHDI
4.33.24.0.10	324	EGIE AMILIA VELISDIONO
4.33.24.0.11	325	FEBY YUANGGI PUTRI
4.33.24.0.12	326	HANIF ALBANA ROZAD
4.33.24.0.13	327	INDRA WIJAYA
4.33.24.0.14	328	JONATHAN EDWARD SINAGA
4.33.24.0.15	329	KATRINA AGNI HARTANTO
4.33.24.0.16	330	MUHAMMAD ALMAHDI
4.33.24.0.17	331	MUHAMMAD FAISAL REZA MUSTOFA
4.33.24.0.18	332	MUHAMMAD RIZKY FADHILA
4.33.24.0.19	333	MUHAMMAD SYAUQI ALGHIFARI
4.33.24.0.20	334	NABILA RAMADANI
4.33.24.0.21	335	NANDA ARIFIA CHOERUNISA
4.33.24.0.22	336	RAFIF ALI FAHREZI
4.33.24.0.23	337	RAKI ABHISTA PRAKOSO
4.33.24.0.24	338	SALMA ZAHRA RAMADHANI
4.33.24.0.25	339	SATRIO ADZI PRIAMBODO
4.33.24.0.26	340	VIAN MAULANA RAMADHAN
4.33.24.1.01	341	ANISA FARCHA NOVIANI
4.33.24.1.02	342	ARJUNA NATHA PRATISENA
4.33.24.1.03	343	ARYODIMAS DZAKI WITRYAWAN
4.33.24.1.04	344	AZKA BARIQLANA
4.33.24.1.05	345	CAHYO GADHANG PUTRO BASKORO
4.33.24.1.06	346	CANTIKA ALIFIA MAHARANI
4.33.24.1.07	347	DEWANGGA RADITYA NUGROHO
4.33.24.1.08	348	EIREN WIBI HIDAYAT
4.33.24.1.09	349	GANANG SYAIFULLAH
4.33.24.1.10	350	HAFIZH IMAN WICAKSONO
4.33.24.1.11	351	KENCANA IKHSANUN NADJA
4.33.24.1.12	352	KHANSA INTANIA UTOMO
4.33.24.1.13	353	MI. AULIA KURNIA WIDYARANI
4.33.24.1.14	354	MUHAMMAD ASDIF AFADA
4.33.24.1.15	355	MUHAMMAD BINTANG SATRIO UTOMO
4.33.24.1.16	356	MUHAMMAD ILHAM RIJAL THAARIQ
4.33.24.1.17	357	MUHAMMAD MUMTAZA AL AFKAR
4.33.24.1.18	358	NAJWA RAHMA HAPSARI
4.33.24.1.19	359	PANDU SETYA NUGRAHA
4.33.24.1.20	360	PUTRI LEVINA AGATHA
4.33.24.1.21	361	RAUL HARYO FAUZIAN
4.33.24.1.22	362	RAY EGANS PRAMUDYA
4.33.24.1.23	363	RIKO ADITYA ZAKI
4.33.24.1.24	364	SENDI PRASETYO
4.33.24.1.25	365	SEPTIA ISNAENI SALSABILA
4.33.24.1.26	366	YUSUF FADHLIH FIRMANSYAH
4.33.24.2.01	367	ABYAN FAZA NARISWANGGA
4.33.24.2.02	368	ADILA DIMAZ BUWANA
4.33.24.2.03	369	ANNISA NAELIL IZATI
4.33.24.2.04	370	BAGASKARA
4.33.24.2.05	371	CEZAR NARESWARA RESPATI
4.33.24.2.06	372	DEVI IBNU NABILA
4.33.24.2.07	373	DIAH DWI ASTUTI
4.33.24.2.08	374	DIMAS ADHIE NUGROHO
4.33.24.2.10	375	GHUFRON AINUN NAJIB
4.33.24.2.11	376	IZZA BAGHUZ SYAFI'I MA'ARIF
4.33.24.2.12	377	M. OKSA SETYARSO
4.33.24.2.13	378	MUHAMMAD HIKMAL ALFARIDZY BACHTIAR
4.33.24.2.14	379	MUHAMMAD IBRAHIM
4.33.24.2.15	380	MUHAMMAD RAFA ENRICO
4.33.24.2.16	381	NABILA AZ ZAHRA MUNIR
4.33.24.2.17	382	PAULUS ALE KRISTIAWAN
4.33.24.2.18	383	RAJABA HAMIM MAUDUDI
4.33.24.2.19	384	RIZTIKA MERISTA INDRIANI
4.33.24.2.20	385	ROIHAN SAPUTRA
4.33.24.2.21	386	SITI MIFTAHUS SA'DIYAH
4.33.24.2.22	387	SRI PUJANGGA
4.33.24.2.23	388	TERRA SURYA NEGARI
4.33.24.2.24	389	ZALFA AZ ZAHRA
4.33.24.2.25	390	ZULFIKRI ARYA PUTRA ISMAIL
4.33.23.0.01	391	ADRIANSYAH ALFARISYI
4.33.23.0.02	392	AGUNG HADI ASTANTO
4.33.23.0.03	393	AHMAD FARKHANI
4.33.23.0.04	394	ANINDHA CAHYA MULIA SALIM
4.33.23.0.05	395	ARIF KURNIA RAHMAN
4.33.23.0.06	396	ATHAYA PANDU MARENO
4.33.23.0.07	397	DANIEL ADI PRATAMA
4.33.23.0.08	398	DAVIN ALIFIANDA ADYTIA
4.33.23.0.09	399	FAJAR DWI FIRMANSYAH
4.33.23.0.10	400	FITRIANA NAYLA NOVIANTI
4.33.23.0.11	401	GILANG MAULANATA PRAMUDYA
4.33.23.0.13	402	ILHAM TARUPRASETYO
4.33.23.0.14	403	IRMA INNAYAH
4.33.23.0.15	404	KHILDA SALSABILA AZKA
4.33.23.0.16	405	MARVELLINA DEVI WURDHANING
4.33.23.0.17	406	MAULANA FAJAR ROHMANI
4.33.23.0.18	407	MILA ROSITA DEWI
4.33.23.0.19	408	MUHAMAD HAYDAR AYDIN ALHAMDANI
4.33.23.0.20	409	MUHAMMAD SYAUQI MAULANA ANANSYAH
4.33.23.0.21	410	MUHAMMAD ZAKIY FADHLULLAH AZHAR
4.33.23.0.22	411	RACHMAD YOGO DWIYANTO
4.33.23.0.23	412	RAFI ARTHAYANA PUTRA DERIZMA
4.33.23.0.26	413	TUBAGUS PRATAMA JULIANTO
4.33.22.1.25	414	TITO WAHYU PRATAMA
4.33.23.1.01	415	AHMAD RIZKIADI BUDI WIRAWAN
4.33.23.1.02	416	AKSOBHYA SAMATHA VARGA
4.33.23.1.03	417	ANINDITA NAJWA EKA SABRINA
4.33.23.1.04	418	ATSIILA ARYA NABIIH
4.33.23.1.05	419	AZANI FATTUR FADHIKA
4.33.23.1.06	420	DANU ALAMSYAH PUTRA
4.33.23.1.07	421	FAISHAL ANANDA RACHMAN
4.33.23.1.08	422	FAJAR WAHYU SURYAPUTRA
4.33.23.1.09	423	HANIF ABDUSY SYAKUR
4.33.23.1.10	424	HELSA CHRISTABEL HARSONO
4.33.23.1.11	425	IBRAHIM ARYAN FARIDZI
4.33.23.1.12	426	IVAN RAKHA ADINATA
4.33.23.1.13	427	JONATHAN ORDRICK EDRA WIJAYA
4.33.23.1.15	428	MIFTACHUSSURUR
4.33.23.1.16	429	MUHAMAD RIFKI SURYA PRATAMA
4.33.23.1.17	430	MUHAMMAD FATWA SYAIKHONI
4.33.23.1.18	431	MUHAMMAD RAFIF PASYA
4.33.23.1.19	432	NICHOLAS ERNESTO ANAK AGUNG
4.33.23.1.20	433	RAHMALYANA AYUNINGTYAS
4.33.23.1.21	434	RASYAD TANZILUR RAHMAN
4.33.23.1.22	435	ROHIMATUN NURIN NADHIFAH
4.33.23.1.23	436	TARISHA NAILA ANGELIN
4.33.23.1.24	437	TRISTAN EKA WIRANATA
4.33.23.1.25	438	WARSENO BAMBANG SETYONO
4.33.23.2.01	439	ADINDA RAHIMAH AZZAHRA
4.33.23.2.02	440	ADJIE RADHITYA KUSSENA
4.33.23.2.03	441	ADNAN BIMA ADHI NUGRAHA
4.33.23.2.04	442	ALDO RAMADHANA
4.33.23.2.05	443	AMMAR LUQMAN ARIFIN
4.33.23.2.06	444	ANINDITA RAHMA AZALIA
4.33.23.2.07	445	AZKA NUR FADEL
4.33.23.2.08	446	BAGUS SADEWA
4.33.23.2.09	447	CHALLISTA RISKIANA
4.33.23.2.10	448	DIRGA PRIYANTO
4.33.23.2.11	449	FAIZ AKMAL NURHAKIM
4.33.23.2.12	450	FATHURRAFI NADIO BUSONO
4.33.23.2.13	451	GHAFARI ARIF JABBAR
4.33.23.2.14	452	HASNA RUMAISHA
4.33.23.2.15	453	ILHAM AJI IRAWAN
4.33.23.2.16	454	ILHAM INDRA ATMAJA
4.33.23.2.17	455	MUHAMAD ZA'IM SETYAWAN
4.33.23.2.18	456	MUHAMMAD DZAKY JAMALUDDIN
4.33.23.2.19	457	MUHAMMAD HAIDAR ALY
4.33.23.2.20	458	MUHAMMAD IMAM MUSTOFA KAMAL
4.33.23.2.21	459	MUHAMMAD JANUAR RIFQI NANDA
4.33.23.2.22	460	MUHAMMAD ROOZIQIN
4.33.23.2.23	461	PRABASWARA SHAFA AZARIOMA
4.33.23.2.24	462	SAHARDIAN PUTRA WIGUNA
4.33.23.2.25	463	SALWA SALSABILA DAFFA'ATULHAQ
4.33.23.2.26	464	ZULVIKAR KHARISMA NUR MUHAMMAD
MHS001	469	Mahasiswa Test
\.


--
-- TOC entry 4452 (class 0 OID 17605)
-- Dependencies: 365
-- Data for Name: menus; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.menus (id, key, label, icon, path, urutan, parent_id, created_at) FROM stdin;
1	dashboard	Dashboard	LayoutDashboard	/user/dashboard	1	\N	2026-04-20 16:48:48.500836
2	pekerjaan	List Pekerjaan	Briefcase	/user/list_perkerjaan	2	\N	2026-04-20 16:48:48.500836
3	ekuivalensi	Ekuivalensi	BookOpen	/user/ekuivalensi	3	\N	2026-04-20 16:48:48.500836
14	dashboard_admin	Dashboard	LayoutDashboard	/admin/dashboard	1	\N	2026-05-10 01:41:52.474978
15	pekerjaan_admin	Pekerjaan	Briefcase	/admin/list_pekerjaan	2	\N	2026-05-10 01:41:52.474978
17	pengaturan	Pengaturan	Settings	/admin/pengaturan	4	\N	2026-05-10 01:41:52.474978
16	laporan	Ekuivalensi	BookOpen	/admin/ekuivalensi	3	\N	2026-05-10 01:41:52.474978
\.


--
-- TOC entry 4454 (class 0 OID 17613)
-- Dependencies: 367
-- Data for Name: pengaturan_sistem; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pengaturan_sistem (id, grup, key, value, tipe_data, keterangan) FROM stdin;
1	kompen	jam_wajib_per_semester	30	integer	Jumlah jam wajib kompen per semester
2	kompen	maks_penugasan_per_mahasiswa	5	integer	Maksimal penugasan aktif per mahasiswa
3	kompen	poin_per_jam	10000	integer	Nilai poin per jam kompen (dalam rupiah)
4	email	smtp_host	smtp.kampus.ac.id	string	SMTP server untuk email
5	email	smtp_port	587	integer	Port SMTP
6	app	nama_aplikasi	Sistem Kompen	string	Nama aplikasi
7	app	logo_url	/assets/logo.png	string	URL logo aplikasi
\.


--
-- TOC entry 4456 (class 0 OID 17619)
-- Dependencies: 369
-- Data for Name: penugasan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.penugasan (id, pekerjaan_id, nim, status_tugas_id, detail_pengerjaan, catatan_verifikasi, diverifikasi_oleh_nip, waktu_verifikasi, created_at, updated_at) FROM stdin;
3	2	220101003	4	{"laporan": "Bersih semua lab", "progress": 100}	Pekerjaan rapi	197501012005011001	2024-12-10 14:00:00	2024-09-25 10:00:00	2024-12-10 14:00:00
4	2	220101004	2	{"catatan": "Masih proses", "progress": 60}	\N	\N	\N	2024-09-26 11:00:00	2024-12-05 09:00:00
5	2	220101005	1	{"progress": 0}	\N	\N	\N	2024-09-27 08:30:00	\N
6	3	220102001	4	{"file": "/tugas/fajar_keuangan.xlsx", "progress": 100}	Data lengkap	197502022006021002	2024-10-20 11:00:00	2024-09-15 13:00:00	2024-10-20 11:00:00
7	4	220105001	4	{"feedback": "Membantu banget", "progress": 100}	Tutor yang baik	197503032007031003	2024-11-15 15:30:00	2024-09-25 09:00:00	2024-11-15 15:30:00
9	5	220101001	4	{"file": "/tugas/andi_survey.xlsx", "progress": 100}	Data lengkap 100 responden	197501012005011001	2024-10-28 10:00:00	2024-10-05 09:00:00	2024-10-28 10:00:00
10	6	220105001	4	{"nilai": "A", "progress": 100}	Asisten yang baik	198001042008041001	2024-12-05 13:00:00	2024-09-15 14:00:00	2024-12-05 13:00:00
11	6	220105002	2	{"progress": 50}	\N	\N	\N	2024-09-16 09:00:00	2024-11-20 10:00:00
12	7	220103001	1	{"progress": 0}	\N	\N	\N	2024-10-01 10:00:00	\N
69	13	2372001	4	{"fileName": "bukti_69_1779335146942.jpg"}	\N	STAF001	2026-05-21 03:48:16.269	2026-05-10 16:27:00.623	2026-05-21 03:45:46.949
1	2	2372001	4	{"nominal": 10000, "fileName": "bukti_1_1779335161191.jpg"}	Selesai dengan baik	STAF001	2026-05-21 03:48:39.126	2024-09-20 08:00:00	2026-05-21 03:46:01.199
57	5	4.33.25.0.06	3	{"fileName": "bukti_57_1779776874304.jpg"}	\N	\N	\N	2026-05-04 07:32:59.019	2026-05-26 06:27:54.307
13	1	210101001	1	\N	\N	\N	\N	2026-05-04 07:32:58.815	\N
14	1	210101002	1	\N	\N	\N	\N	2026-05-04 07:32:58.824	\N
15	1	220101001	1	\N	\N	\N	\N	2026-05-04 07:32:58.827	\N
16	1	220101002	1	\N	\N	\N	\N	2026-05-04 07:32:58.831	\N
17	1	220101003	1	\N	\N	\N	\N	2026-05-04 07:32:58.847	\N
18	2	220102001	1	\N	\N	\N	\N	2026-05-04 07:32:58.853	\N
19	2	220102002	1	\N	\N	\N	\N	2026-05-04 07:32:58.859	\N
20	2	220104001	1	\N	\N	\N	\N	2026-05-04 07:32:58.865	\N
21	2	220105001	1	\N	\N	\N	\N	2026-05-04 07:32:58.87	\N
22	2	220105003	1	\N	\N	\N	\N	2026-05-04 07:32:58.873	\N
23	2	220106001	1	\N	\N	\N	\N	2026-05-04 07:32:58.878	\N
24	2	4.33.22.1.25	1	\N	\N	\N	\N	2026-05-04 07:32:58.881	\N
25	2	4.33.23.0.01	1	\N	\N	\N	\N	2026-05-04 07:32:58.886	\N
26	3	4.33.23.0.03	1	\N	\N	\N	\N	2026-05-04 07:32:58.891	\N
27	3	4.33.23.0.06	1	\N	\N	\N	\N	2026-05-04 07:32:58.898	\N
28	3	4.33.23.0.11	1	\N	\N	\N	\N	2026-05-04 07:32:58.902	\N
29	8	4.33.23.0.17	1	\N	\N	\N	\N	2026-05-04 07:32:58.906	\N
30	8	4.33.23.0.18	1	\N	\N	\N	\N	2026-05-04 07:32:58.911	\N
31	9	4.33.23.0.26	1	\N	\N	\N	\N	2026-05-04 07:32:58.915	\N
32	9	4.33.23.1.16	1	\N	\N	\N	\N	2026-05-04 07:32:58.919	\N
33	9	4.33.23.1.17	1	\N	\N	\N	\N	2026-05-04 07:32:58.923	\N
34	9	4.33.23.1.24	1	\N	\N	\N	\N	2026-05-04 07:32:58.927	\N
35	4	4.33.23.2.02	1	\N	\N	\N	\N	2026-05-04 07:32:58.932	\N
36	4	4.33.23.2.03	1	\N	\N	\N	\N	2026-05-04 07:32:58.935	\N
37	4	4.33.23.2.07	1	\N	\N	\N	\N	2026-05-04 07:32:58.94	\N
38	4	4.33.23.2.10	1	\N	\N	\N	\N	2026-05-04 07:32:58.943	\N
39	4	4.33.23.2.11	1	\N	\N	\N	\N	2026-05-04 07:32:58.947	\N
40	4	4.33.23.2.13	1	\N	\N	\N	\N	2026-05-04 07:32:58.949	\N
41	4	4.33.23.2.16	1	\N	\N	\N	\N	2026-05-04 07:32:58.953	\N
42	4	4.33.23.2.20	1	\N	\N	\N	\N	2026-05-04 07:32:58.956	\N
43	5	4.33.23.2.22	1	\N	\N	\N	\N	2026-05-04 07:32:58.961	\N
44	5	4.33.23.2.23	1	\N	\N	\N	\N	2026-05-04 07:32:58.964	\N
45	5	4.33.23.2.24	1	\N	\N	\N	\N	2026-05-04 07:32:58.969	\N
47	5	4.33.24.0.01	1	\N	\N	\N	\N	2026-05-04 07:32:58.978	\N
48	5	4.33.24.0.06	1	\N	\N	\N	\N	2026-05-04 07:32:58.982	\N
49	5	4.33.24.1.07	1	\N	\N	\N	\N	2026-05-04 07:32:58.985	\N
50	5	4.33.24.1.08	1	\N	\N	\N	\N	2026-05-04 07:32:58.989	\N
51	5	4.33.24.1.13	1	\N	\N	\N	\N	2026-05-04 07:32:58.998	\N
53	5	4.33.24.2.20	1	\N	\N	\N	\N	2026-05-04 07:32:59.005	\N
54	5	4.33.24.2.22	1	\N	\N	\N	\N	2026-05-04 07:32:59.009	\N
55	5	4.33.24.2.23	1	\N	\N	\N	\N	2026-05-04 07:32:59.013	\N
56	5	4.33.24.2.25	1	\N	\N	\N	\N	2026-05-04 07:32:59.016	\N
58	6	4.33.25.0.21	1	\N	\N	\N	\N	2026-05-04 07:32:59.024	\N
59	6	4.33.25.1.05	1	\N	\N	\N	\N	2026-05-04 07:32:59.027	\N
60	6	4.33.25.1.24	1	\N	\N	\N	\N	2026-05-04 07:32:59.031	\N
61	6	4.33.25.2.01	1	\N	\N	\N	\N	2026-05-04 07:32:59.034	\N
62	7	4.33.25.2.04	1	\N	\N	\N	\N	2026-05-04 07:32:59.038	\N
63	7	4.33.25.2.10	1	\N	\N	\N	\N	2026-05-04 07:32:59.041	\N
64	11	4.33.25.2.12	1	\N	\N	\N	\N	2026-05-04 07:32:59.045	\N
65	11	4.33.25.2.20	1	\N	\N	\N	\N	2026-05-04 07:32:59.047	\N
66	11	4.33.25.2.23	1	\N	\N	\N	\N	2026-05-04 07:32:59.052	\N
67	11	210101001	1	\N	\N	\N	\N	2026-05-04 07:32:59.057	\N
68	11	210101002	1	\N	\N	\N	\N	2026-05-04 07:32:59.06	\N
8	4	220105002	2	{"catatan": "Tinggal 2 sesi lagi", "progress": 80}	gblk	\N	\N	2024-09-26 10:00:00	2024-11-10 14:00:00
2	1	220101002	4	{"file": "/tugas/budi_perpus.pdf", "progress": 100}	\N	STAF001	2026-05-21 03:42:49.35	2024-09-21 09:00:00	2024-10-10 10:00:00
46	5	4.33.23.2.26	1	{"fileName": "bukti_46_1779337031211.jpg"}	\N	STAF001	2026-05-21 04:34:45.42	2026-05-04 07:32:58.975	2026-05-21 04:17:11.216
70	10	4.33.25.1.05	1	\N	\N	\N	\N	2026-05-11 08:14:12.144	\N
71	12	4.33.23.0.06	1	\N	\N	\N	\N	2026-05-11 08:14:12.16	\N
72	13	4.33.25.1.24	1	\N	\N	\N	\N	2026-05-11 08:14:12.163	\N
73	13	4.33.23.2.03	1	\N	\N	\N	\N	2026-05-11 08:14:12.165	\N
74	10	4.33.23.0.01	1	\N	\N	\N	\N	2026-05-26 06:18:24.105	\N
75	14	4.33.23.0.26	1	\N	\N	\N	\N	2026-05-26 06:18:24.114	\N
76	14	4.33.24.1.08	1	\N	\N	\N	\N	2026-05-26 06:18:24.117	\N
77	14	4.33.24.1.13	1	\N	\N	\N	\N	2026-05-26 06:18:24.121	\N
52	5	4.33.24.2.17	4	{"fileName": "bukti_52_1781155041111.jpg"}	\N	STAF001	2026-06-11 05:17:47.105	2026-05-04 07:32:59.002	2026-06-11 05:17:21.116
\.


--
-- TOC entry 4458 (class 0 OID 17626)
-- Dependencies: 371
-- Data for Name: prodi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.prodi (id, jurusan_id, nama_prodi) FROM stdin;
1	1	Teknik Informatika
2	1	Teknik Sipil
3	1	Teknik Elektro
4	1	Teknik Mesin
5	2	Manajemen
6	2	Akuntansi
7	2	Ekonomi Pembangunan
8	3	Ilmu Komputer
9	3	Sistem Informasi
10	4	Ilmu Hukum
\.


--
-- TOC entry 4460 (class 0 OID 17632)
-- Dependencies: 373
-- Data for Name: ref_status_ekuivalensi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ref_status_ekuivalensi (id, nama) FROM stdin;
1	MENUNGGU
2	DISETUJUI
3	DITOLAK
\.


--
-- TOC entry 4461 (class 0 OID 17637)
-- Dependencies: 374
-- Data for Name: ref_status_import; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ref_status_import (id, nama) FROM stdin;
1	SELESAI
2	GAGAL
\.


--
-- TOC entry 4462 (class 0 OID 17642)
-- Dependencies: 375
-- Data for Name: ref_status_tugas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ref_status_tugas (id, nama) FROM stdin;
1	Menunggu
2	Sedang Dikerjakan
3	Selesai
4	Diverifikasi
5	Ditolak
\.


--
-- TOC entry 4463 (class 0 OID 17647)
-- Dependencies: 376
-- Data for Name: ref_tipe_pekerjaan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ref_tipe_pekerjaan (id, nama) FROM stdin;
1	Internal
2	External
\.


--
-- TOC entry 4464 (class 0 OID 17652)
-- Dependencies: 377
-- Data for Name: registrasi_mahasiswa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.registrasi_mahasiswa (id, nim, semester_id, kelas_id, status) FROM stdin;
2	4.33.25.0.02	1	16	Aktif
3	4.33.25.0.03	1	16	Aktif
4	4.33.25.0.04	1	16	Aktif
5	4.33.25.0.05	1	16	Aktif
6	4.33.25.0.06	1	16	Aktif
7	4.33.25.0.07	1	16	Aktif
8	4.33.25.0.08	1	16	Aktif
9	4.33.25.0.09	1	16	Aktif
10	4.33.25.0.10	1	16	Aktif
11	4.33.25.0.11	1	16	Aktif
12	4.33.25.0.12	1	16	Aktif
13	4.33.25.0.13	1	16	Aktif
14	4.33.25.0.14	1	16	Aktif
15	4.33.25.0.15	1	16	Aktif
16	4.33.25.0.16	1	16	Aktif
17	4.33.25.0.17	1	16	Aktif
18	4.33.25.0.18	1	16	Aktif
19	4.33.25.0.19	1	16	Aktif
20	4.33.25.0.20	1	16	Aktif
21	4.33.25.0.21	1	16	Aktif
22	4.33.25.0.22	1	16	Aktif
23	4.33.25.0.23	1	16	Aktif
24	4.33.25.0.24	1	16	Aktif
25	4.33.25.0.25	1	16	Aktif
26	4.33.25.1.01	1	17	Aktif
27	4.33.25.1.02	1	17	Aktif
28	4.33.25.1.03	1	17	Aktif
29	4.33.25.1.04	1	17	Aktif
30	4.33.25.1.05	1	17	Aktif
31	4.33.25.1.06	1	17	Aktif
32	4.33.25.1.07	1	17	Aktif
33	4.33.25.1.08	1	17	Aktif
34	4.33.25.1.09	1	17	Aktif
35	4.33.25.1.10	1	17	Aktif
36	4.33.25.1.11	1	17	Aktif
37	4.33.25.1.12	1	17	Aktif
38	4.33.25.1.13	1	17	Aktif
39	4.33.25.1.14	1	17	Aktif
40	4.33.25.1.15	1	17	Aktif
41	4.33.25.1.16	1	17	Aktif
42	4.33.25.1.17	1	17	Aktif
43	4.33.25.1.18	1	17	Aktif
44	4.33.25.1.19	1	17	Aktif
45	4.33.25.1.20	1	17	Aktif
46	4.33.25.1.21	1	17	Aktif
47	4.33.25.1.22	1	17	Aktif
48	4.33.25.1.23	1	17	Aktif
49	4.33.25.1.24	1	17	Aktif
50	4.33.25.1.25	1	17	Aktif
51	4.33.25.1.26	1	17	Aktif
52	4.33.25.2.01	1	18	Aktif
53	4.33.25.2.02	1	18	Aktif
54	4.33.25.2.03	1	18	Aktif
55	4.33.25.2.04	1	18	Aktif
56	4.33.25.2.05	1	18	Aktif
57	4.33.25.2.06	1	18	Aktif
58	4.33.25.2.07	1	18	Aktif
59	4.33.25.2.08	1	18	Aktif
60	4.33.25.2.09	1	18	Aktif
61	4.33.25.2.10	1	18	Aktif
62	4.33.25.2.11	1	18	Aktif
63	4.33.25.2.12	1	18	Aktif
64	4.33.25.2.13	1	18	Aktif
65	4.33.25.2.14	1	18	Aktif
66	4.33.25.2.15	1	18	Aktif
67	4.33.25.2.16	1	18	Aktif
68	4.33.25.2.17	1	18	Aktif
69	4.33.25.2.18	1	18	Aktif
70	4.33.25.2.19	1	18	Aktif
71	4.33.25.2.20	1	18	Aktif
72	4.33.25.2.21	1	18	Aktif
73	4.33.25.2.22	1	18	Aktif
74	4.33.25.2.23	1	18	Aktif
75	4.33.25.2.24	1	18	Aktif
76	4.33.25.2.25	1	18	Aktif
77	4.33.24.0.01	1	19	Aktif
78	4.33.24.0.02	1	19	Aktif
79	4.33.24.0.03	1	19	Aktif
80	4.33.24.0.04	1	19	Aktif
81	4.33.24.0.05	1	19	Aktif
82	4.33.24.0.06	1	19	Aktif
83	4.33.24.0.07	1	19	Aktif
84	4.33.24.0.08	1	19	Aktif
85	4.33.24.0.09	1	19	Aktif
86	4.33.24.0.10	1	19	Aktif
87	4.33.24.0.11	1	19	Aktif
88	4.33.24.0.12	1	19	Aktif
89	4.33.24.0.13	1	19	Aktif
90	4.33.24.0.14	1	19	Aktif
91	4.33.24.0.15	1	19	Aktif
92	4.33.24.0.16	1	19	Aktif
93	4.33.24.0.17	1	19	Aktif
94	4.33.24.0.18	1	19	Aktif
95	4.33.24.0.19	1	19	Aktif
96	4.33.24.0.20	1	19	Aktif
97	4.33.24.0.21	1	19	Aktif
98	4.33.24.0.22	1	19	Aktif
99	4.33.24.0.23	1	19	Aktif
100	4.33.24.0.24	1	19	Aktif
101	4.33.24.0.25	1	19	Aktif
102	4.33.24.0.26	1	19	Aktif
103	4.33.24.1.01	1	20	Aktif
104	4.33.24.1.02	1	20	Aktif
105	4.33.24.1.03	1	20	Aktif
106	4.33.24.1.04	1	20	Aktif
107	4.33.24.1.05	1	20	Aktif
108	4.33.24.1.06	1	20	Aktif
109	4.33.24.1.07	1	20	Aktif
110	4.33.24.1.08	1	20	Aktif
111	4.33.24.1.09	1	20	Aktif
112	4.33.24.1.10	1	20	Aktif
113	4.33.24.1.11	1	20	Aktif
114	4.33.24.1.12	1	20	Aktif
115	4.33.24.1.13	1	20	Aktif
116	4.33.24.1.14	1	20	Aktif
117	4.33.24.1.15	1	20	Aktif
118	4.33.24.1.16	1	20	Aktif
119	4.33.24.1.17	1	20	Aktif
120	4.33.24.1.18	1	20	Aktif
121	4.33.24.1.19	1	20	Aktif
122	4.33.24.1.20	1	20	Aktif
123	4.33.24.1.21	1	20	Aktif
124	4.33.24.1.22	1	20	Aktif
125	4.33.24.1.23	1	20	Aktif
126	4.33.24.1.24	1	20	Aktif
127	4.33.24.1.25	1	20	Aktif
128	4.33.24.1.26	1	20	Aktif
129	4.33.24.2.01	1	21	Aktif
130	4.33.24.2.02	1	21	Aktif
131	4.33.24.2.03	1	21	Aktif
132	4.33.24.2.04	1	21	Aktif
133	4.33.24.2.05	1	21	Aktif
134	4.33.24.2.06	1	21	Aktif
135	4.33.24.2.07	1	21	Aktif
136	4.33.24.2.08	1	21	Aktif
137	4.33.24.2.10	1	21	Aktif
138	4.33.24.2.11	1	21	Aktif
139	4.33.24.2.12	1	21	Aktif
140	4.33.24.2.13	1	21	Aktif
141	4.33.24.2.14	1	21	Aktif
142	4.33.24.2.15	1	21	Aktif
143	4.33.24.2.16	1	21	Aktif
144	4.33.24.2.17	1	21	Aktif
145	4.33.24.2.18	1	21	Aktif
146	4.33.24.2.19	1	21	Aktif
147	4.33.24.2.20	1	21	Aktif
148	4.33.24.2.21	1	21	Aktif
149	4.33.24.2.22	1	21	Aktif
150	4.33.24.2.23	1	21	Aktif
151	4.33.24.2.24	1	21	Aktif
152	4.33.24.2.25	1	21	Aktif
153	4.33.23.0.01	1	22	Aktif
154	4.33.23.0.02	1	22	Aktif
155	4.33.23.0.03	1	22	Aktif
156	4.33.23.0.04	1	22	Aktif
157	4.33.23.0.05	1	22	Aktif
158	4.33.23.0.06	1	22	Aktif
159	4.33.23.0.07	1	22	Aktif
160	4.33.23.0.08	1	22	Aktif
161	4.33.23.0.09	1	22	Aktif
162	4.33.23.0.10	1	22	Aktif
163	4.33.23.0.11	1	22	Aktif
164	4.33.23.0.13	1	22	Aktif
165	4.33.23.0.14	1	22	Aktif
166	4.33.23.0.15	1	22	Aktif
167	4.33.23.0.16	1	22	Aktif
168	4.33.23.0.17	1	22	Aktif
169	4.33.23.0.18	1	22	Aktif
170	4.33.23.0.19	1	22	Aktif
171	4.33.23.0.20	1	22	Aktif
172	4.33.23.0.21	1	22	Aktif
173	4.33.23.0.22	1	22	Aktif
174	4.33.23.0.23	1	22	Aktif
175	4.33.23.0.26	1	22	Aktif
176	4.33.22.1.25	1	23	Aktif
177	4.33.23.1.01	1	23	Aktif
178	4.33.23.1.02	1	23	Aktif
179	4.33.23.1.03	1	23	Aktif
180	4.33.23.1.04	1	23	Aktif
181	4.33.23.1.05	1	23	Aktif
182	4.33.23.1.06	1	23	Aktif
183	4.33.23.1.07	1	23	Aktif
184	4.33.23.1.08	1	23	Aktif
185	4.33.23.1.09	1	23	Aktif
186	4.33.23.1.10	1	23	Aktif
187	4.33.23.1.11	1	23	Aktif
188	4.33.23.1.12	1	23	Aktif
189	4.33.23.1.13	1	23	Aktif
190	4.33.23.1.15	1	23	Aktif
191	4.33.23.1.16	1	23	Aktif
192	4.33.23.1.17	1	23	Aktif
193	4.33.23.1.18	1	23	Aktif
194	4.33.23.1.19	1	23	Aktif
195	4.33.23.1.20	1	23	Aktif
196	4.33.23.1.21	1	23	Aktif
197	4.33.23.1.22	1	23	Aktif
198	4.33.23.1.23	1	23	Aktif
199	4.33.23.1.24	1	23	Aktif
200	4.33.23.1.25	1	23	Aktif
201	4.33.23.2.01	1	24	Aktif
202	4.33.23.2.02	1	24	Aktif
203	4.33.23.2.03	1	24	Aktif
204	4.33.23.2.04	1	24	Aktif
205	4.33.23.2.05	1	24	Aktif
206	4.33.23.2.06	1	24	Aktif
207	4.33.23.2.07	1	24	Aktif
208	4.33.23.2.08	1	24	Aktif
209	4.33.23.2.09	1	24	Aktif
210	4.33.23.2.10	1	24	Aktif
211	4.33.23.2.11	1	24	Aktif
212	4.33.23.2.12	1	24	Aktif
213	4.33.23.2.13	1	24	Aktif
214	4.33.23.2.14	1	24	Aktif
215	4.33.23.2.15	1	24	Aktif
216	4.33.23.2.16	1	24	Aktif
217	4.33.23.2.17	1	24	Aktif
218	4.33.23.2.18	1	24	Aktif
219	4.33.23.2.19	1	24	Aktif
220	4.33.23.2.20	1	24	Aktif
221	4.33.23.2.21	1	24	Aktif
222	4.33.23.2.22	1	24	Aktif
223	4.33.23.2.23	1	24	Aktif
224	4.33.23.2.24	1	24	Aktif
225	4.33.23.2.25	1	24	Aktif
226	4.33.23.2.26	1	24	Aktif
227	2372001	1	1	Aktif
1	4.33.25.0.01	1	1	Aktif
\.


--
-- TOC entry 4466 (class 0 OID 17659)
-- Dependencies: 379
-- Data for Name: role_has_menus; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role_has_menus (id, created_at, role_id, menus_id) FROM stdin;
10	2026-05-09 18:41:52.474978+00	1	14
11	2026-05-09 18:41:52.474978+00	1	15
12	2026-05-09 18:41:52.474978+00	1	16
13	2026-05-09 18:41:52.474978+00	1	17
14	2026-05-09 18:41:52.474978+00	2	14
15	2026-05-09 18:41:52.474978+00	2	15
16	2026-05-09 18:41:52.474978+00	4	14
17	2026-05-09 18:41:52.474978+00	3	1
18	2026-05-09 18:41:52.474978+00	3	2
19	2026-05-09 18:41:52.474978+00	3	3
20	2026-05-09 18:44:38.741587+00	2	16
\.


--
-- TOC entry 4468 (class 0 OID 17664)
-- Dependencies: 381
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, nama, key_menu, key_condition) FROM stdin;
1	Super Admin	["all"]	{"all": true}
2	Staf Jurusan	["daftar_pekerjaan", "penugasan", "verifikasi"]	{"jurusan_only": true}
3	Mahasiswa	["pekerjaan", "riwayat", "profil"]	{"self_only": true}
4	Dosen	["verifikasi", "laporan"]	{"jurusan_only": true}
\.


--
-- TOC entry 4469 (class 0 OID 17669)
-- Dependencies: 382
-- Data for Name: ruangan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ruangan (id, gedung_id, nama_ruangan, kode_ruangan) FROM stdin;
1	1	Ruang Kuliah A101	A101
2	1	Ruang Kuliah A102	A102
3	1	Laboratorium Komputer A	LAB-A
4	2	Ruang Kuliah B201	B201
5	2	Ruang Sidang Teknik	RS-TK
6	3	Ruang Kuliah C301	C301
7	3	Laboratorium Ekonomi	LAB-EK
8	4	Ruang Kuliah D401	D401
9	4	Laboratorium Ilkom	LAB-ILKOM
10	5	Ruang Kuliah E501	E501
11	6	Laboratorium Pusat A	LAB-PUSAT
12	7	Digital Lab	DIGILAB
\.


--
-- TOC entry 4471 (class 0 OID 17675)
-- Dependencies: 384
-- Data for Name: semester; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.semester (id, nama, tahun, periode, is_aktif, mulai, selesai) FROM stdin;
2	Genap 2023/2024	2024	Genap	f	2024-02-01	2024-06-30
3	Ganjil 2023/2024	2023	Ganjil	f	2023-09-01	2024-01-15
4	Pendek 2024	2024	Pendek	f	2024-07-01	2024-08-30
1	Ganjil 2024/2025	2027	Ganjil	t	2024-09-01	2025-01-15
\.


--
-- TOC entry 4473 (class 0 OID 17682)
-- Dependencies: 386
-- Data for Name: staf; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.staf (nip, user_id, nama, jurusan_id, tipe_staf) FROM stdin;
197501012005011001	2	Dr. Ahmad Wijaya, S.T., M.T.	1	staf_jurusan
197502022006021002	3	Dr. Budi Santoso, S.E., M.E.	2	staf_jurusan
197503032007031003	4	Ir. Cipto Junaedy, M.Kom.	3	staf_jurusan
198001042008041001	5	Prof. Dedi Mulyadi, S.H., M.H.	4	dosen
198002052009051002	6	Dr. Eka Putri, S.Si., M.Si.	1	dosen
ADMIN001	466	Super Admin	1	admin
DOSEN001	468	Dosen Penguji	1	dosen
STAF001	467	mama ghufron	1	staf_jurusan
\.


--
-- TOC entry 4474 (class 0 OID 17687)
-- Dependencies: 387
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, email, kata_sandi, role_id, created_at) FROM stdin;
3	staf_ekonomi@kampus.ac.id	$2a$10$encrypted_hash_here	2	2026-04-20 16:48:48.516293
4	staf_ilkom@kampus.ac.id	$2a$10$encrypted_hash_here	2	2026-04-20 16:48:48.516293
5	dosen_budi@kampus.ac.id	$2a$10$encrypted_hash_here	4	2026-04-20 16:48:48.516293
6	dosen_siti@kampus.ac.id	$2a$10$encrypted_hash_here	4	2026-04-20 16:48:48.516293
7	mahasiswa1@kampus.ac.id	$2a$10$encrypted_hash_here	3	2026-04-20 16:48:48.516293
8	mahasiswa2@kampus.ac.id	$2a$10$encrypted_hash_here	3	2026-04-20 16:48:48.516293
9	mahasiswa3@kampus.ac.id	$2a$10$encrypted_hash_here	3	2026-04-20 16:48:48.516293
10	mahasiswa4@kampus.ac.id	$2a$10$encrypted_hash_here	3	2026-04-20 16:48:48.516293
11	mahasiswa5@kampus.ac.id	$2a$10$encrypted_hash_here	3	2026-04-20 16:48:48.516293
240	43325002@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.669
241	43325003@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.683
242	43325004@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.703
243	43325005@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.717
244	43325006@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.736
245	43325007@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.75
246	43325008@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.766
247	43325009@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.78
248	43325010@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.795
249	43325011@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.811
250	43325012@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.826
251	43325013@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.843
252	43325014@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.863
253	43325015@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.877
254	43325016@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.892
255	43325017@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.908
256	43325018@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.923
257	43325019@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.939
258	43325020@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.954
259	43325021@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.966
260	43325022@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.982
261	43325023@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.996
262	43325024@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.014
263	43325025@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.028
264	43325101@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.044
265	43325102@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.059
266	43325103@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.077
267	43325104@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.093
268	43325105@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.104
269	43325106@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.124
270	43325107@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.139
271	43325108@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.158
272	43325109@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.174
273	43325110@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.195
274	43325111@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.208
275	43325112@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.226
276	43325113@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.242
277	43325114@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.26
278	43325115@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.274
279	43325116@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.289
280	43325117@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.303
281	43325118@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.316
282	43325119@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.334
283	43325120@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.351
284	43325121@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.367
285	43325122@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.381
286	43325123@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.399
287	43325124@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.413
288	43325125@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.429
289	43325126@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.45
290	43325201@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.466
291	43325202@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.48
292	43325203@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.521
293	43325204@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.535
294	43325205@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.549
295	43325206@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.565
296	43325207@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.577
297	43325208@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.592
298	43325209@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.609
299	43325210@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.622
300	43325211@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.639
301	43325212@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.653
302	43325213@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.671
303	43325214@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.685
304	43325215@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.704
305	43325216@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.717
306	43325217@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.732
307	43325218@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.747
308	43325219@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.761
309	43325220@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.778
310	43325221@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.791
311	43325222@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.808
312	43325223@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.832
313	43325224@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.844
314	43325225@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.856
315	43324001@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.872
316	43324002@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.887
317	43324003@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.9
318	43324004@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.916
319	43324005@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.927
320	43324006@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.939
321	43324007@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.954
322	43324008@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.966
323	43324009@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.98
324	43324010@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.994
325	43324011@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.01
326	43324012@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.026
327	43324013@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.039
328	43324014@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.055
329	43324015@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.071
330	43324016@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.087
331	43324017@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.102
332	43324018@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.116
333	43324019@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.129
334	43324020@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.143
335	43324021@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.155
336	43324022@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.166
337	43324023@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.179
338	43324024@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.194
339	43324025@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.206
340	43324026@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.217
341	43324101@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.23
342	43324102@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.241
343	43324103@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.256
344	43324104@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.271
345	43324105@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.282
346	43324106@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.297
347	43324107@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.31
348	43324108@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.32
349	43324109@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.334
350	43324110@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.344
351	43324111@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.355
352	43324112@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.37
353	43324113@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.38
354	43324114@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.392
355	43324115@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.405
356	43324116@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.419
357	43324117@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.433
358	43324118@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.444
359	43324119@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.459
360	43324120@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.473
361	43324121@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.483
362	43324122@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.498
363	43324123@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.512
364	43324124@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.523
365	43324125@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.537
366	43324126@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.548
367	43324201@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.559
368	43324202@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.573
369	43324203@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.583
370	43324204@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.594
371	43324205@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.609
372	43324206@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.621
373	43324207@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.634
374	43324208@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.654
375	43324210@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.664
376	43324211@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.68
377	43324212@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.692
378	43324213@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.706
379	43324214@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.721
380	43324215@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.735
381	43324216@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.749
382	43324217@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.763
383	43324218@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.775
384	43324219@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.788
385	43324220@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.801
386	43324221@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.816
387	43324222@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.831
388	43324223@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.845
389	43324224@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.857
390	43324225@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.875
391	43323001@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.891
392	43323002@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.903
393	43323003@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.916
394	43323004@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.928
395	43323005@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.937
396	43323006@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.946
397	43323007@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.96
398	43323008@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.972
399	43323009@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.989
400	43323010@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.002
401	43323011@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.013
402	43323013@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.026
403	43323014@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.037
404	43323015@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.047
405	43323016@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.061
406	43323017@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.07
407	43323018@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.082
408	43323019@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.098
409	43323020@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.111
410	43323021@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.123
411	43323022@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.134
412	43323023@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.145
413	43323026@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.155
414	43322125@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.17
415	43323101@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.18
416	43323102@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.193
417	43323103@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.206
418	43323104@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.222
419	43323105@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.238
420	43323106@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.254
421	43323107@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.27
422	43323108@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.284
423	43323109@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.302
424	43323110@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.319
425	43323111@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.334
426	43323112@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.346
427	43323113@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.359
428	43323115@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.373
429	43323116@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.387
430	43323117@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.402
431	43323118@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.417
432	43323119@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.43
433	43323120@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.449
434	43323121@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.464
435	43323122@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.48
436	43323123@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.493
437	43323124@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.507
438	43323125@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.526
439	43323201@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.55
440	43323202@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.568
441	43323203@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.594
442	43323204@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.615
443	43323205@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.631
444	43323206@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.661
445	43323207@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.682
446	43323208@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.7
447	43323209@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.721
448	43323210@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.735
449	43323211@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.762
450	43323212@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.776
451	43323213@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.792
452	43323214@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.806
453	43323215@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.822
454	43323216@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.836
455	43323217@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.858
456	43323218@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.871
457	43323219@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.885
458	43323220@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.902
459	43323221@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.916
460	43323222@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.932
461	43323223@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.946
462	43323224@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.963
463	43323225@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.978
464	43323226@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.995
466	admin@kampus.ac.id	$2b$10$E0J87FgzbOn0ObPk3YM2MOitTWUHncZ19gZ7En8btAZcNozIjXKuS	1	2026-05-10 01:24:06.800893
468	dosen@kampus.ac.id	$2b$10$gh.SLH4khGlOdz.PC6UsGurK8.awheser.2Hyz2PLJNE1Zm5/l38K	4	2026-05-10 01:24:06.800893
469	mhs@kampus.ac.id	$2b$10$sg2EUaOQCOYE/Scxh3s7xu/BDSoEhsu7ZIpVBdDjOq7lfm9r60Ynq	3	2026-05-10 01:24:06.800893
467	gufron@kampus.ac.id	$2b$10$t4W7xcgPZLyPs8e9eNb53.Ua2eZ1xNbjPGOSkje.yIWMWVa7mHrBy	2	2026-05-10 01:24:06.800893
12	2372001@student.polines.ac.id	$2b$10$nahxFaFGgEpxGBb2iDZwBeG7a3mbEpFEAXQ.xMaJUj9C2fhZBkh4K	3	2026-04-27 23:26:57.954988
2	staf_teknik@kampus.ac.id	$2a$10$encrypted_hash_here	2	2026-04-20 16:48:48.516293
239	43325001@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	1	2026-05-03 13:18:25.636
\.


--
-- TOC entry 4424 (class 0 OID 17170)
-- Dependencies: 333
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2026-06-01 13:18:52
20211116045059	2026-06-01 13:18:53
20211116050929	2026-06-01 13:18:53
20211116051442	2026-06-01 13:18:54
20211116212300	2026-06-01 13:18:55
20211116213355	2026-06-01 13:18:56
20211116213934	2026-06-01 13:18:56
20211116214523	2026-06-01 13:18:57
20211122062447	2026-06-01 13:18:58
20211124070109	2026-06-01 13:18:59
20211202204204	2026-06-01 13:18:59
20211202204605	2026-06-01 13:19:00
20211210212804	2026-06-01 13:19:02
20211228014915	2026-06-01 13:19:03
20220107221237	2026-06-01 13:19:03
20220228202821	2026-06-01 13:19:04
20220312004840	2026-06-01 13:19:05
20220603231003	2026-06-01 13:19:06
20220603232444	2026-06-01 13:19:07
20220615214548	2026-06-01 13:19:07
20220712093339	2026-06-01 13:19:08
20220908172859	2026-06-01 13:19:09
20220916233421	2026-06-01 13:19:10
20230119133233	2026-06-01 13:19:10
20230128025114	2026-06-01 13:19:11
20230128025212	2026-06-01 13:19:12
20230227211149	2026-06-01 13:19:13
20230228184745	2026-06-01 13:19:13
20230308225145	2026-06-01 13:19:14
20230328144023	2026-06-01 13:19:15
20231018144023	2026-06-01 13:19:15
20231204144023	2026-06-01 13:19:17
20231204144024	2026-06-01 13:19:17
20231204144025	2026-06-01 13:19:18
20240108234812	2026-06-01 13:19:19
20240109165339	2026-06-01 13:19:19
20240227174441	2026-06-01 13:19:20
20240311171622	2026-06-01 13:19:21
20240321100241	2026-06-01 13:19:23
20240401105812	2026-06-01 13:19:25
20240418121054	2026-06-01 13:19:26
20240523004032	2026-06-01 13:19:29
20240618124746	2026-06-01 13:19:29
20240801235015	2026-06-01 13:19:30
20240805133720	2026-06-01 13:19:31
20240827160934	2026-06-01 13:19:32
20240919163303	2026-06-01 13:19:33
20240919163305	2026-06-01 13:19:34
20241019105805	2026-06-01 13:19:34
20241030150047	2026-06-01 13:19:37
20241108114728	2026-06-01 13:19:38
20241121104152	2026-06-01 13:19:39
20241130184212	2026-06-01 13:19:40
20241220035512	2026-06-01 13:19:40
20241220123912	2026-06-01 13:19:41
20241224161212	2026-06-01 13:19:42
20250107150512	2026-06-01 13:19:43
20250110162412	2026-06-01 13:19:43
20250123174212	2026-06-01 13:19:44
20250128220012	2026-06-01 13:19:45
20250506224012	2026-06-01 13:19:46
20250523164012	2026-06-01 13:19:46
20250714121412	2026-06-01 13:19:47
20250905041441	2026-06-01 13:19:48
20251103001201	2026-06-01 13:19:49
20251120212548	2026-06-01 13:19:50
20251120215549	2026-06-01 13:19:50
20260218120000	2026-06-01 13:19:51
20260326120000	2026-06-01 13:19:52
20260514120000	2026-06-11 05:06:47
20260527120000	2026-06-11 05:06:49
20260528120000	2026-06-11 05:06:50
20260603120000	2026-06-11 05:06:51
\.


--
-- TOC entry 4434 (class 0 OID 17383)
-- Dependencies: 344
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at, action_filter, selected_columns) FROM stdin;
\.


--
-- TOC entry 4426 (class 0 OID 17183)
-- Dependencies: 335
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id, type) FROM stdin;
\.


--
-- TOC entry 4430 (class 0 OID 17302)
-- Dependencies: 339
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets_analytics (name, type, format, created_at, updated_at, id, deleted_at) FROM stdin;
\.


--
-- TOC entry 4431 (class 0 OID 17315)
-- Dependencies: 340
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets_vectors (id, type, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4425 (class 0 OID 17175)
-- Dependencies: 334
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2026-06-01 12:10:03.076625
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2026-06-01 12:10:03.127539
2	storage-schema	f6a1fa2c93cbcd16d4e487b362e45fca157a8dbd	2026-06-01 12:10:03.134446
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2026-06-01 12:10:03.176888
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2026-06-01 12:10:03.195653
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2026-06-01 12:10:03.204068
6	change-column-name-in-get-size	ded78e2f1b5d7e616117897e6443a925965b30d2	2026-06-01 12:10:03.212345
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2026-06-01 12:10:03.22095
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2026-06-01 12:10:03.281615
9	fix-search-function	af597a1b590c70519b464a4ab3be54490712796b	2026-06-01 12:10:03.289756
10	search-files-search-function	b595f05e92f7e91211af1bbfe9c6a13bb3391e16	2026-06-01 12:10:03.297452
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2026-06-01 12:10:03.308464
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2026-06-01 12:10:03.31534
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2026-06-01 12:10:03.320978
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2026-06-01 12:10:03.326613
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2026-06-01 12:10:03.382267
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2026-06-01 12:10:03.389283
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2026-06-01 12:10:03.395066
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2026-06-01 12:10:03.401051
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2026-06-01 12:10:03.409324
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2026-06-01 12:10:03.415226
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2026-06-01 12:10:03.424719
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2026-06-01 12:10:03.444197
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2026-06-01 12:10:03.460957
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2026-06-01 12:10:03.467365
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2026-06-01 12:10:03.472895
26	objects-prefixes	215cabcb7f78121892a5a2037a09fedf9a1ae322	2026-06-01 12:10:03.478288
27	search-v2	859ba38092ac96eb3964d83bf53ccc0b141663a6	2026-06-01 12:10:03.48624
28	object-bucket-name-sorting	c73a2b5b5d4041e39705814fd3a1b95502d38ce4	2026-06-01 12:10:03.491895
29	create-prefixes	ad2c1207f76703d11a9f9007f821620017a66c21	2026-06-01 12:10:03.497539
30	update-object-levels	2be814ff05c8252fdfdc7cfb4b7f5c7e17f0bed6	2026-06-01 12:10:03.502806
31	objects-level-index	b40367c14c3440ec75f19bbce2d71e914ddd3da0	2026-06-01 12:10:03.508509
32	backward-compatible-index-on-objects	e0c37182b0f7aee3efd823298fb3c76f1042c0f7	2026-06-01 12:10:03.51326
33	backward-compatible-index-on-prefixes	b480e99ed951e0900f033ec4eb34b5bdcb4e3d49	2026-06-01 12:10:03.518091
34	optimize-search-function-v1	ca80a3dc7bfef894df17108785ce29a7fc8ee456	2026-06-01 12:10:03.522909
35	add-insert-trigger-prefixes	458fe0ffd07ec53f5e3ce9df51bfdf4861929ccc	2026-06-01 12:10:03.527759
36	optimise-existing-functions	6ae5fca6af5c55abe95369cd4f93985d1814ca8f	2026-06-01 12:10:03.533416
37	add-bucket-name-length-trigger	3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1	2026-06-01 12:10:03.538339
38	iceberg-catalog-flag-on-buckets	02716b81ceec9705aed84aa1501657095b32e5c5	2026-06-01 12:10:03.545428
39	add-search-v2-sort-support	6706c5f2928846abee18461279799ad12b279b78	2026-06-01 12:10:03.561901
40	fix-prefix-race-conditions-optimized	7ad69982ae2d372b21f48fc4829ae9752c518f6b	2026-06-01 12:10:03.568069
41	add-object-level-update-trigger	07fcf1a22165849b7a029deed059ffcde08d1ae0	2026-06-01 12:10:03.573015
42	rollback-prefix-triggers	771479077764adc09e2ea2043eb627503c034cd4	2026-06-01 12:10:03.578067
43	fix-object-level	84b35d6caca9d937478ad8a797491f38b8c2979f	2026-06-01 12:10:03.588408
44	vector-bucket-type	99c20c0ffd52bb1ff1f32fb992f3b351e3ef8fb3	2026-06-01 12:10:03.596198
45	vector-buckets	049e27196d77a7cb76497a85afae669d8b230953	2026-06-01 12:10:03.602305
46	buckets-objects-grants	fedeb96d60fefd8e02ab3ded9fbde05632f84aed	2026-06-01 12:10:03.680045
47	iceberg-table-metadata	649df56855c24d8b36dd4cc1aeb8251aa9ad42c2	2026-06-01 12:10:03.69174
48	iceberg-catalog-ids	e0e8b460c609b9999ccd0df9ad14294613eed939	2026-06-01 12:10:03.697233
49	buckets-objects-grants-postgres	072b1195d0d5a2f888af6b2302a1938dd94b8b3d	2026-06-01 12:10:03.732166
50	search-v2-optimised	6323ac4f850aa14e7387eb32102869578b5bd478	2026-06-01 12:10:03.738638
51	index-backward-compatible-search	2ee395d433f76e38bcd3856debaf6e0e5b674011	2026-06-01 12:10:04.657201
52	drop-not-used-indexes-and-functions	5cc44c8696749ac11dd0dc37f2a3802075f3a171	2026-06-01 12:10:04.659272
53	drop-index-lower-name	d0cb18777d9e2a98ebe0bc5cc7a42e57ebe41854	2026-06-01 12:10:04.671725
54	drop-index-object-level	6289e048b1472da17c31a7eba1ded625a6457e67	2026-06-01 12:10:04.674933
55	prevent-direct-deletes	262a4798d5e0f2e7c8970232e03ce8be695d5819	2026-06-01 12:10:04.676928
56	fix-optimized-search-function	b823ed1e418101032fa01374edc9a436e54e3ed4	2026-06-01 12:10:04.683663
57	s3-multipart-uploads-metadata	f127886e00d1b374fadbc7c6b31e09336aad5287	2026-06-01 12:10:04.691561
58	operation-ergonomics	00ca5d483b3fe0d522133d9002ccc5df98365120	2026-06-01 12:10:04.69893
59	drop-unused-functions	38456f13e39691c2bbb4b5151d0d1cdbabd4a8c4	2026-06-01 12:10:04.807229
60	optimize-existing-functions-again	db35e1c91a9201e59f4fef8d972c2f277d68b157	2026-06-01 12:10:04.816073
\.


--
-- TOC entry 4427 (class 0 OID 17193)
-- Dependencies: 336
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata) FROM stdin;
\.


--
-- TOC entry 4428 (class 0 OID 17242)
-- Dependencies: 337
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata, metadata) FROM stdin;
\.


--
-- TOC entry 4429 (class 0 OID 17256)
-- Dependencies: 338
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- TOC entry 4432 (class 0 OID 17325)
-- Dependencies: 341
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.vector_indexes (id, name, bucket_id, data_type, dimension, distance_metric, metadata_configuration, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 3790 (class 0 OID 16612)
-- Dependencies: 313
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4686 (class 0 OID 0)
-- Dependencies: 308
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 1, false);


--
-- TOC entry 4687 (class 0 OID 0)
-- Dependencies: 349
-- Name: daftar_pekerjaan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.daftar_pekerjaan_id_seq', 14, true);


--
-- TOC entry 4688 (class 0 OID 0)
-- Dependencies: 351
-- Name: ekuivalensi_kelas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ekuivalensi_kelas_id_seq', 32, true);


--
-- TOC entry 4689 (class 0 OID 0)
-- Dependencies: 353
-- Name: gedung_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.gedung_id_seq', 7, true);


--
-- TOC entry 4690 (class 0 OID 0)
-- Dependencies: 355
-- Name: import_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.import_log_id_seq', 14, true);


--
-- TOC entry 4691 (class 0 OID 0)
-- Dependencies: 357
-- Name: jurusan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.jurusan_id_seq', 4, true);


--
-- TOC entry 4692 (class 0 OID 0)
-- Dependencies: 359
-- Name: kelas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kelas_id_seq', 24, true);


--
-- TOC entry 4693 (class 0 OID 0)
-- Dependencies: 361
-- Name: kompen_awal_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kompen_awal_id_seq', 245, true);


--
-- TOC entry 4694 (class 0 OID 0)
-- Dependencies: 363
-- Name: log_potong_jam_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.log_potong_jam_id_seq', 72, true);


--
-- TOC entry 4695 (class 0 OID 0)
-- Dependencies: 366
-- Name: menus_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.menus_id_seq', 17, true);


--
-- TOC entry 4696 (class 0 OID 0)
-- Dependencies: 368
-- Name: pengaturan_sistem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pengaturan_sistem_id_seq', 7, true);


--
-- TOC entry 4697 (class 0 OID 0)
-- Dependencies: 370
-- Name: penugasan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.penugasan_id_seq', 77, true);


--
-- TOC entry 4698 (class 0 OID 0)
-- Dependencies: 372
-- Name: prodi_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.prodi_id_seq', 10, true);


--
-- TOC entry 4699 (class 0 OID 0)
-- Dependencies: 378
-- Name: registrasi_mahasiswa_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.registrasi_mahasiswa_id_seq', 227, true);


--
-- TOC entry 4700 (class 0 OID 0)
-- Dependencies: 380
-- Name: role_has_menus_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.role_has_menus_id_seq', 20, true);


--
-- TOC entry 4701 (class 0 OID 0)
-- Dependencies: 383
-- Name: ruangan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ruangan_id_seq', 12, true);


--
-- TOC entry 4702 (class 0 OID 0)
-- Dependencies: 385
-- Name: semester_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.semester_id_seq', 4, true);


--
-- TOC entry 4703 (class 0 OID 0)
-- Dependencies: 388
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 469, true);


--
-- TOC entry 4704 (class 0 OID 0)
-- Dependencies: 343
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: supabase_admin
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- TOC entry 3996 (class 2606 OID 16789)
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- TOC entry 3965 (class 2606 OID 16535)
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- TOC entry 4051 (class 2606 OID 17121)
-- Name: custom_oauth_providers custom_oauth_providers_identifier_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_identifier_key UNIQUE (identifier);


--
-- TOC entry 4053 (class 2606 OID 17119)
-- Name: custom_oauth_providers custom_oauth_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_pkey PRIMARY KEY (id);


--
-- TOC entry 4019 (class 2606 OID 16895)
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- TOC entry 3974 (class 2606 OID 16913)
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- TOC entry 3976 (class 2606 OID 16923)
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- TOC entry 3963 (class 2606 OID 16528)
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- TOC entry 3998 (class 2606 OID 16782)
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- TOC entry 3994 (class 2606 OID 16770)
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- TOC entry 3986 (class 2606 OID 16963)
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- TOC entry 3988 (class 2606 OID 16757)
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- TOC entry 4032 (class 2606 OID 17022)
-- Name: oauth_authorizations oauth_authorizations_authorization_code_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_code_key UNIQUE (authorization_code);


--
-- TOC entry 4034 (class 2606 OID 17020)
-- Name: oauth_authorizations oauth_authorizations_authorization_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_id_key UNIQUE (authorization_id);


--
-- TOC entry 4036 (class 2606 OID 17018)
-- Name: oauth_authorizations oauth_authorizations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_pkey PRIMARY KEY (id);


--
-- TOC entry 4046 (class 2606 OID 17080)
-- Name: oauth_client_states oauth_client_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_client_states
    ADD CONSTRAINT oauth_client_states_pkey PRIMARY KEY (id);


--
-- TOC entry 4029 (class 2606 OID 16982)
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- TOC entry 4040 (class 2606 OID 17044)
-- Name: oauth_consents oauth_consents_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_pkey PRIMARY KEY (id);


--
-- TOC entry 4042 (class 2606 OID 17046)
-- Name: oauth_consents oauth_consents_user_client_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_client_unique UNIQUE (user_id, client_id);


--
-- TOC entry 4023 (class 2606 OID 16948)
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 3957 (class 2606 OID 16518)
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 3960 (class 2606 OID 16699)
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- TOC entry 4008 (class 2606 OID 16829)
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- TOC entry 4010 (class 2606 OID 16827)
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- TOC entry 4015 (class 2606 OID 16843)
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- TOC entry 3968 (class 2606 OID 16541)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 3981 (class 2606 OID 16720)
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 4005 (class 2606 OID 16810)
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- TOC entry 4000 (class 2606 OID 16801)
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- TOC entry 3950 (class 2606 OID 16883)
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- TOC entry 3952 (class 2606 OID 16505)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4061 (class 2606 OID 17158)
-- Name: webauthn_challenges webauthn_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_pkey PRIMARY KEY (id);


--
-- TOC entry 4057 (class 2606 OID 17141)
-- Name: webauthn_credentials webauthn_credentials_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_pkey PRIMARY KEY (id);


--
-- TOC entry 4099 (class 2606 OID 17712)
-- Name: daftar_pekerjaan daftar_pekerjaan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daftar_pekerjaan
    ADD CONSTRAINT daftar_pekerjaan_pkey PRIMARY KEY (id);


--
-- TOC entry 4101 (class 2606 OID 17714)
-- Name: ekuivalensi_kelas ekuivalensi_kelas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ekuivalensi_kelas
    ADD CONSTRAINT ekuivalensi_kelas_pkey PRIMARY KEY (id);


--
-- TOC entry 4103 (class 2606 OID 17716)
-- Name: gedung gedung_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gedung
    ADD CONSTRAINT gedung_pkey PRIMARY KEY (id);


--
-- TOC entry 4105 (class 2606 OID 17718)
-- Name: import_log import_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.import_log
    ADD CONSTRAINT import_log_pkey PRIMARY KEY (id);


--
-- TOC entry 4107 (class 2606 OID 17720)
-- Name: jurusan jurusan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jurusan
    ADD CONSTRAINT jurusan_pkey PRIMARY KEY (id);


--
-- TOC entry 4109 (class 2606 OID 17722)
-- Name: kelas kelas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kelas
    ADD CONSTRAINT kelas_pkey PRIMARY KEY (id);


--
-- TOC entry 4111 (class 2606 OID 17724)
-- Name: kompen_awal kompen_awal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kompen_awal
    ADD CONSTRAINT kompen_awal_pkey PRIMARY KEY (id);


--
-- TOC entry 4113 (class 2606 OID 17726)
-- Name: log_potong_jam log_potong_jam_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_potong_jam
    ADD CONSTRAINT log_potong_jam_pkey PRIMARY KEY (id);


--
-- TOC entry 4115 (class 2606 OID 17730)
-- Name: mahasiswa mahasiswa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mahasiswa
    ADD CONSTRAINT mahasiswa_pkey PRIMARY KEY (nim);


--
-- TOC entry 4117 (class 2606 OID 17732)
-- Name: mahasiswa mahasiswa_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mahasiswa
    ADD CONSTRAINT mahasiswa_user_id_key UNIQUE (user_id);


--
-- TOC entry 4119 (class 2606 OID 17734)
-- Name: menus menus_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menus
    ADD CONSTRAINT menus_key_key UNIQUE (key);


--
-- TOC entry 4121 (class 2606 OID 17736)
-- Name: menus menus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menus
    ADD CONSTRAINT menus_pkey PRIMARY KEY (id);


--
-- TOC entry 4123 (class 2606 OID 17738)
-- Name: pengaturan_sistem pengaturan_sistem_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pengaturan_sistem
    ADD CONSTRAINT pengaturan_sistem_key_key UNIQUE (key);


--
-- TOC entry 4125 (class 2606 OID 17740)
-- Name: pengaturan_sistem pengaturan_sistem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pengaturan_sistem
    ADD CONSTRAINT pengaturan_sistem_pkey PRIMARY KEY (id);


--
-- TOC entry 4127 (class 2606 OID 17742)
-- Name: penugasan penugasan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.penugasan
    ADD CONSTRAINT penugasan_pkey PRIMARY KEY (id);


--
-- TOC entry 4129 (class 2606 OID 17744)
-- Name: prodi prodi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prodi
    ADD CONSTRAINT prodi_pkey PRIMARY KEY (id);


--
-- TOC entry 4131 (class 2606 OID 17746)
-- Name: ref_status_ekuivalensi ref_status_ekuivalensi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ref_status_ekuivalensi
    ADD CONSTRAINT ref_status_ekuivalensi_pkey PRIMARY KEY (id);


--
-- TOC entry 4133 (class 2606 OID 17748)
-- Name: ref_status_import ref_status_import_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ref_status_import
    ADD CONSTRAINT ref_status_import_pkey PRIMARY KEY (id);


--
-- TOC entry 4135 (class 2606 OID 17750)
-- Name: ref_status_tugas ref_status_tugas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ref_status_tugas
    ADD CONSTRAINT ref_status_tugas_pkey PRIMARY KEY (id);


--
-- TOC entry 4137 (class 2606 OID 17752)
-- Name: ref_tipe_pekerjaan ref_tipe_pekerjaan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ref_tipe_pekerjaan
    ADD CONSTRAINT ref_tipe_pekerjaan_pkey PRIMARY KEY (id);


--
-- TOC entry 4139 (class 2606 OID 17754)
-- Name: registrasi_mahasiswa registrasi_mahasiswa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registrasi_mahasiswa
    ADD CONSTRAINT registrasi_mahasiswa_pkey PRIMARY KEY (id);


--
-- TOC entry 4141 (class 2606 OID 17756)
-- Name: registrasi_mahasiswa registrasi_mahasiswa_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registrasi_mahasiswa
    ADD CONSTRAINT registrasi_mahasiswa_unique UNIQUE (nim, semester_id);


--
-- TOC entry 4143 (class 2606 OID 17758)
-- Name: role_has_menus role_has_menus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_has_menus
    ADD CONSTRAINT role_has_menus_pkey PRIMARY KEY (id);


--
-- TOC entry 4145 (class 2606 OID 17760)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 4147 (class 2606 OID 17762)
-- Name: ruangan ruangan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ruangan
    ADD CONSTRAINT ruangan_pkey PRIMARY KEY (id);


--
-- TOC entry 4149 (class 2606 OID 17764)
-- Name: semester semester_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.semester
    ADD CONSTRAINT semester_pkey PRIMARY KEY (id);


--
-- TOC entry 4151 (class 2606 OID 17766)
-- Name: staf staf_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staf
    ADD CONSTRAINT staf_pkey PRIMARY KEY (nip);


--
-- TOC entry 4153 (class 2606 OID 17768)
-- Name: staf staf_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staf
    ADD CONSTRAINT staf_user_id_key UNIQUE (user_id);


--
-- TOC entry 4155 (class 2606 OID 17770)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 4157 (class 2606 OID 17772)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 3935 (class 2606 OID 25367)
-- Name: messages messages_payload_exclusive; Type: CHECK CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages
    ADD CONSTRAINT messages_payload_exclusive CHECK (((payload IS NULL) OR (binary_payload IS NULL))) NOT VALID;


--
-- TOC entry 4097 (class 2606 OID 17537)
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4093 (class 2606 OID 17391)
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- TOC entry 4064 (class 2606 OID 17174)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 4084 (class 2606 OID 17348)
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- TOC entry 4071 (class 2606 OID 17191)
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- TOC entry 4087 (class 2606 OID 17324)
-- Name: buckets_vectors buckets_vectors_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_vectors
    ADD CONSTRAINT buckets_vectors_pkey PRIMARY KEY (id);


--
-- TOC entry 4066 (class 2606 OID 17182)
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- TOC entry 4068 (class 2606 OID 17180)
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 4077 (class 2606 OID 17203)
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- TOC entry 4082 (class 2606 OID 17265)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- TOC entry 4080 (class 2606 OID 17250)
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- TOC entry 4090 (class 2606 OID 17334)
-- Name: vector_indexes vector_indexes_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_pkey PRIMARY KEY (id);


--
-- TOC entry 3966 (class 1259 OID 16536)
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- TOC entry 3936 (class 1259 OID 16709)
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4047 (class 1259 OID 17125)
-- Name: custom_oauth_providers_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_created_at_idx ON auth.custom_oauth_providers USING btree (created_at);


--
-- TOC entry 4048 (class 1259 OID 17124)
-- Name: custom_oauth_providers_enabled_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_enabled_idx ON auth.custom_oauth_providers USING btree (enabled);


--
-- TOC entry 4049 (class 1259 OID 17122)
-- Name: custom_oauth_providers_identifier_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_identifier_idx ON auth.custom_oauth_providers USING btree (identifier);


--
-- TOC entry 4054 (class 1259 OID 17123)
-- Name: custom_oauth_providers_provider_type_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_provider_type_idx ON auth.custom_oauth_providers USING btree (provider_type);


--
-- TOC entry 3937 (class 1259 OID 16711)
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 3938 (class 1259 OID 16712)
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 3984 (class 1259 OID 16791)
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- TOC entry 4017 (class 1259 OID 16899)
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- TOC entry 3972 (class 1259 OID 16879)
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- TOC entry 4705 (class 0 OID 0)
-- Dependencies: 3972
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- TOC entry 3977 (class 1259 OID 16706)
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- TOC entry 4020 (class 1259 OID 16896)
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- TOC entry 4044 (class 1259 OID 17081)
-- Name: idx_oauth_client_states_created_at; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_oauth_client_states_created_at ON auth.oauth_client_states USING btree (created_at);


--
-- TOC entry 4021 (class 1259 OID 16897)
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- TOC entry 3939 (class 1259 OID 17167)
-- Name: idx_users_created_at_desc; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_users_created_at_desc ON auth.users USING btree (created_at DESC);


--
-- TOC entry 3940 (class 1259 OID 17166)
-- Name: idx_users_email; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_users_email ON auth.users USING btree (email);


--
-- TOC entry 3941 (class 1259 OID 17168)
-- Name: idx_users_last_sign_in_at_desc; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_users_last_sign_in_at_desc ON auth.users USING btree (last_sign_in_at DESC);


--
-- TOC entry 3942 (class 1259 OID 17169)
-- Name: idx_users_name; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_users_name ON auth.users USING btree (((raw_user_meta_data ->> 'name'::text))) WHERE ((raw_user_meta_data ->> 'name'::text) IS NOT NULL);


--
-- TOC entry 3992 (class 1259 OID 16902)
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- TOC entry 3989 (class 1259 OID 16763)
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- TOC entry 3990 (class 1259 OID 16908)
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- TOC entry 4030 (class 1259 OID 17033)
-- Name: oauth_auth_pending_exp_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_auth_pending_exp_idx ON auth.oauth_authorizations USING btree (expires_at) WHERE (status = 'pending'::auth.oauth_authorization_status);


--
-- TOC entry 4027 (class 1259 OID 16986)
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- TOC entry 4037 (class 1259 OID 17059)
-- Name: oauth_consents_active_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_client_idx ON auth.oauth_consents USING btree (client_id) WHERE (revoked_at IS NULL);


--
-- TOC entry 4038 (class 1259 OID 17057)
-- Name: oauth_consents_active_user_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_user_client_idx ON auth.oauth_consents USING btree (user_id, client_id) WHERE (revoked_at IS NULL);


--
-- TOC entry 4043 (class 1259 OID 17058)
-- Name: oauth_consents_user_order_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_user_order_idx ON auth.oauth_consents USING btree (user_id, granted_at DESC);


--
-- TOC entry 4024 (class 1259 OID 16955)
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- TOC entry 4025 (class 1259 OID 16954)
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- TOC entry 4026 (class 1259 OID 16956)
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- TOC entry 3943 (class 1259 OID 16713)
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 3944 (class 1259 OID 16710)
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 3953 (class 1259 OID 16519)
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- TOC entry 3954 (class 1259 OID 16520)
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- TOC entry 3955 (class 1259 OID 16705)
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- TOC entry 3958 (class 1259 OID 16793)
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- TOC entry 3961 (class 1259 OID 16898)
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- TOC entry 4011 (class 1259 OID 16835)
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- TOC entry 4012 (class 1259 OID 16900)
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- TOC entry 4013 (class 1259 OID 16850)
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- TOC entry 4016 (class 1259 OID 16849)
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- TOC entry 3978 (class 1259 OID 16901)
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- TOC entry 3979 (class 1259 OID 17071)
-- Name: sessions_oauth_client_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_oauth_client_id_idx ON auth.sessions USING btree (oauth_client_id);


--
-- TOC entry 3982 (class 1259 OID 16792)
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- TOC entry 4003 (class 1259 OID 16817)
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- TOC entry 4006 (class 1259 OID 16816)
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- TOC entry 4001 (class 1259 OID 16802)
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- TOC entry 4002 (class 1259 OID 16964)
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- TOC entry 3991 (class 1259 OID 16961)
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- TOC entry 3983 (class 1259 OID 16790)
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- TOC entry 3945 (class 1259 OID 16870)
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- TOC entry 4706 (class 0 OID 0)
-- Dependencies: 3945
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- TOC entry 3946 (class 1259 OID 16707)
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- TOC entry 3947 (class 1259 OID 16509)
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- TOC entry 3948 (class 1259 OID 16925)
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- TOC entry 4059 (class 1259 OID 17165)
-- Name: webauthn_challenges_expires_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_challenges_expires_at_idx ON auth.webauthn_challenges USING btree (expires_at);


--
-- TOC entry 4062 (class 1259 OID 17164)
-- Name: webauthn_challenges_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_challenges_user_id_idx ON auth.webauthn_challenges USING btree (user_id);


--
-- TOC entry 4055 (class 1259 OID 17147)
-- Name: webauthn_credentials_credential_id_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX webauthn_credentials_credential_id_key ON auth.webauthn_credentials USING btree (credential_id);


--
-- TOC entry 4058 (class 1259 OID 17148)
-- Name: webauthn_credentials_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_credentials_user_id_idx ON auth.webauthn_credentials USING btree (user_id);


--
-- TOC entry 4091 (class 1259 OID 17538)
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- TOC entry 4095 (class 1259 OID 17539)
-- Name: messages_inserted_at_topic_index; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_inserted_at_topic_index ON ONLY realtime.messages USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4094 (class 1259 OID 25375)
-- Name: subscription_subscription_id_entity_filters_action_filter_selec; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_action_filter_selec ON realtime.subscription USING btree (subscription_id, entity, filters, action_filter, COALESCE(selected_columns, '{}'::text[]));


--
-- TOC entry 4069 (class 1259 OID 17192)
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- TOC entry 4072 (class 1259 OID 17209)
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- TOC entry 4085 (class 1259 OID 17349)
-- Name: buckets_analytics_unique_name_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX buckets_analytics_unique_name_idx ON storage.buckets_analytics USING btree (name) WHERE (deleted_at IS NULL);


--
-- TOC entry 4078 (class 1259 OID 17276)
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- TOC entry 4073 (class 1259 OID 17241)
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- TOC entry 4074 (class 1259 OID 17356)
-- Name: idx_objects_bucket_id_name_lower; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name_lower ON storage.objects USING btree (bucket_id, lower(name) COLLATE "C");


--
-- TOC entry 4075 (class 1259 OID 17210)
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- TOC entry 4088 (class 1259 OID 17340)
-- Name: vector_indexes_name_bucket_id_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX vector_indexes_name_bucket_id_idx ON storage.vector_indexes USING btree (name, bucket_id);


--
-- TOC entry 4373 (class 2618 OID 17707)
-- Name: v_status_pekerjaan _RETURN; Type: RULE; Schema: public; Owner: postgres
--

CREATE OR REPLACE VIEW public.v_status_pekerjaan AS
 SELECT dp.id AS pekerjaan_id,
    dp.judul,
    dp.kuota,
    dp.poin_jam,
    dp.is_aktif,
    count(p.id) FILTER (WHERE (p.status_tugas_id <> 5)) AS kuota_terisi,
    (dp.kuota - count(p.id) FILTER (WHERE (p.status_tugas_id <> 5))) AS sisa_slot
   FROM (public.daftar_pekerjaan dp
     LEFT JOIN public.penugasan p ON ((p.pekerjaan_id = dp.id)))
  GROUP BY dp.id;


--
-- TOC entry 4222 (class 2620 OID 17396)
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: supabase_admin
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- TOC entry 4218 (class 2620 OID 17295)
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- TOC entry 4219 (class 2620 OID 17358)
-- Name: buckets protect_buckets_delete; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_buckets_delete BEFORE DELETE ON storage.buckets FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- TOC entry 4220 (class 2620 OID 17359)
-- Name: objects protect_objects_delete; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_objects_delete BEFORE DELETE ON storage.objects FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- TOC entry 4221 (class 2620 OID 17229)
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- TOC entry 4159 (class 2606 OID 16693)
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4164 (class 2606 OID 16783)
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- TOC entry 4163 (class 2606 OID 16771)
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- TOC entry 4162 (class 2606 OID 16758)
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4170 (class 2606 OID 17023)
-- Name: oauth_authorizations oauth_authorizations_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- TOC entry 4171 (class 2606 OID 17028)
-- Name: oauth_authorizations oauth_authorizations_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4172 (class 2606 OID 17052)
-- Name: oauth_consents oauth_consents_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- TOC entry 4173 (class 2606 OID 17047)
-- Name: oauth_consents oauth_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4169 (class 2606 OID 16949)
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4158 (class 2606 OID 16726)
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- TOC entry 4166 (class 2606 OID 16830)
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 4167 (class 2606 OID 16903)
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- TOC entry 4168 (class 2606 OID 16844)
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 4160 (class 2606 OID 17066)
-- Name: sessions sessions_oauth_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_oauth_client_id_fkey FOREIGN KEY (oauth_client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- TOC entry 4161 (class 2606 OID 16721)
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4165 (class 2606 OID 16811)
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 4175 (class 2606 OID 17159)
-- Name: webauthn_challenges webauthn_challenges_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4174 (class 2606 OID 17142)
-- Name: webauthn_credentials webauthn_credentials_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4181 (class 2606 OID 17774)
-- Name: daftar_pekerjaan daftar_pekerjaan_ruangan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daftar_pekerjaan
    ADD CONSTRAINT daftar_pekerjaan_ruangan_id_fkey FOREIGN KEY (ruangan_id) REFERENCES public.ruangan(id);


--
-- TOC entry 4182 (class 2606 OID 17779)
-- Name: daftar_pekerjaan daftar_pekerjaan_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daftar_pekerjaan
    ADD CONSTRAINT daftar_pekerjaan_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES public.semester(id);


--
-- TOC entry 4183 (class 2606 OID 17784)
-- Name: daftar_pekerjaan daftar_pekerjaan_staf_nip_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daftar_pekerjaan
    ADD CONSTRAINT daftar_pekerjaan_staf_nip_fkey FOREIGN KEY (staf_nip) REFERENCES public.staf(nip);


--
-- TOC entry 4184 (class 2606 OID 17789)
-- Name: daftar_pekerjaan daftar_pekerjaan_tipe_pekerjaan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daftar_pekerjaan
    ADD CONSTRAINT daftar_pekerjaan_tipe_pekerjaan_id_fkey FOREIGN KEY (tipe_pekerjaan_id) REFERENCES public.ref_tipe_pekerjaan(id);


--
-- TOC entry 4185 (class 2606 OID 17794)
-- Name: ekuivalensi_kelas ekuivalensi_kelas_kelas_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ekuivalensi_kelas
    ADD CONSTRAINT ekuivalensi_kelas_kelas_id_fkey FOREIGN KEY (kelas_id) REFERENCES public.kelas(id);


--
-- TOC entry 4186 (class 2606 OID 17799)
-- Name: ekuivalensi_kelas ekuivalensi_kelas_penanggung_jawab_nim_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ekuivalensi_kelas
    ADD CONSTRAINT ekuivalensi_kelas_penanggung_jawab_nim_fkey FOREIGN KEY (penanggung_jawab_nim) REFERENCES public.mahasiswa(nim);


--
-- TOC entry 4187 (class 2606 OID 17804)
-- Name: ekuivalensi_kelas ekuivalensi_kelas_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ekuivalensi_kelas
    ADD CONSTRAINT ekuivalensi_kelas_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES public.semester(id);


--
-- TOC entry 4188 (class 2606 OID 17809)
-- Name: ekuivalensi_kelas ekuivalensi_kelas_status_ekuivalensi_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ekuivalensi_kelas
    ADD CONSTRAINT ekuivalensi_kelas_status_ekuivalensi_id_fkey FOREIGN KEY (status_ekuivalensi_id) REFERENCES public.ref_status_ekuivalensi(id);


--
-- TOC entry 4189 (class 2606 OID 17814)
-- Name: ekuivalensi_kelas ekuivalensi_kelas_verified_by_nip_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ekuivalensi_kelas
    ADD CONSTRAINT ekuivalensi_kelas_verified_by_nip_fkey FOREIGN KEY (verified_by_nip) REFERENCES public.staf(nip);


--
-- TOC entry 4190 (class 2606 OID 17819)
-- Name: gedung gedung_jurusan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gedung
    ADD CONSTRAINT gedung_jurusan_id_fkey FOREIGN KEY (jurusan_id) REFERENCES public.jurusan(id);


--
-- TOC entry 4191 (class 2606 OID 17824)
-- Name: import_log import_log_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.import_log
    ADD CONSTRAINT import_log_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES public.semester(id);


--
-- TOC entry 4192 (class 2606 OID 17829)
-- Name: import_log import_log_staf_nip_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.import_log
    ADD CONSTRAINT import_log_staf_nip_fkey FOREIGN KEY (staf_nip) REFERENCES public.staf(nip);


--
-- TOC entry 4193 (class 2606 OID 17834)
-- Name: import_log import_log_status_import_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.import_log
    ADD CONSTRAINT import_log_status_import_id_fkey FOREIGN KEY (status_import_id) REFERENCES public.ref_status_import(id);


--
-- TOC entry 4194 (class 2606 OID 17839)
-- Name: kelas kelas_prodi_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kelas
    ADD CONSTRAINT kelas_prodi_id_fkey FOREIGN KEY (prodi_id) REFERENCES public.prodi(id);


--
-- TOC entry 4195 (class 2606 OID 17844)
-- Name: kompen_awal kompen_awal_import_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kompen_awal
    ADD CONSTRAINT kompen_awal_import_id_fkey FOREIGN KEY (import_id) REFERENCES public.import_log(id);


--
-- TOC entry 4196 (class 2606 OID 17849)
-- Name: kompen_awal kompen_awal_nim_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kompen_awal
    ADD CONSTRAINT kompen_awal_nim_fkey FOREIGN KEY (nim) REFERENCES public.mahasiswa(nim);


--
-- TOC entry 4197 (class 2606 OID 17854)
-- Name: kompen_awal kompen_awal_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kompen_awal
    ADD CONSTRAINT kompen_awal_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES public.semester(id);


--
-- TOC entry 4198 (class 2606 OID 17859)
-- Name: log_potong_jam log_potong_jam_ekuivalensi_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_potong_jam
    ADD CONSTRAINT log_potong_jam_ekuivalensi_id_fkey FOREIGN KEY (ekuivalensi_id) REFERENCES public.ekuivalensi_kelas(id);


--
-- TOC entry 4199 (class 2606 OID 17864)
-- Name: log_potong_jam log_potong_jam_nim_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_potong_jam
    ADD CONSTRAINT log_potong_jam_nim_fkey FOREIGN KEY (nim) REFERENCES public.mahasiswa(nim);


--
-- TOC entry 4200 (class 2606 OID 17869)
-- Name: log_potong_jam log_potong_jam_penugasan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_potong_jam
    ADD CONSTRAINT log_potong_jam_penugasan_id_fkey FOREIGN KEY (penugasan_id) REFERENCES public.penugasan(id);


--
-- TOC entry 4201 (class 2606 OID 17874)
-- Name: log_potong_jam log_potong_jam_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_potong_jam
    ADD CONSTRAINT log_potong_jam_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES public.semester(id);


--
-- TOC entry 4202 (class 2606 OID 17879)
-- Name: mahasiswa mahasiswa_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mahasiswa
    ADD CONSTRAINT mahasiswa_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 4203 (class 2606 OID 17884)
-- Name: menus menus_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menus
    ADD CONSTRAINT menus_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.menus(id);


--
-- TOC entry 4204 (class 2606 OID 17889)
-- Name: penugasan penugasan_diverifikasi_oleh_nip_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.penugasan
    ADD CONSTRAINT penugasan_diverifikasi_oleh_nip_fkey FOREIGN KEY (diverifikasi_oleh_nip) REFERENCES public.staf(nip);


--
-- TOC entry 4205 (class 2606 OID 17894)
-- Name: penugasan penugasan_nim_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.penugasan
    ADD CONSTRAINT penugasan_nim_fkey FOREIGN KEY (nim) REFERENCES public.mahasiswa(nim);


--
-- TOC entry 4206 (class 2606 OID 17899)
-- Name: penugasan penugasan_pekerjaan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.penugasan
    ADD CONSTRAINT penugasan_pekerjaan_id_fkey FOREIGN KEY (pekerjaan_id) REFERENCES public.daftar_pekerjaan(id);


--
-- TOC entry 4207 (class 2606 OID 17904)
-- Name: penugasan penugasan_status_tugas_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.penugasan
    ADD CONSTRAINT penugasan_status_tugas_id_fkey FOREIGN KEY (status_tugas_id) REFERENCES public.ref_status_tugas(id);


--
-- TOC entry 4208 (class 2606 OID 17909)
-- Name: prodi prodi_jurusan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prodi
    ADD CONSTRAINT prodi_jurusan_id_fkey FOREIGN KEY (jurusan_id) REFERENCES public.jurusan(id);


--
-- TOC entry 4209 (class 2606 OID 17914)
-- Name: registrasi_mahasiswa registrasi_mahasiswa_kelas_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registrasi_mahasiswa
    ADD CONSTRAINT registrasi_mahasiswa_kelas_id_fkey FOREIGN KEY (kelas_id) REFERENCES public.kelas(id);


--
-- TOC entry 4210 (class 2606 OID 17919)
-- Name: registrasi_mahasiswa registrasi_mahasiswa_nim_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registrasi_mahasiswa
    ADD CONSTRAINT registrasi_mahasiswa_nim_fkey FOREIGN KEY (nim) REFERENCES public.mahasiswa(nim);


--
-- TOC entry 4211 (class 2606 OID 17924)
-- Name: registrasi_mahasiswa registrasi_mahasiswa_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registrasi_mahasiswa
    ADD CONSTRAINT registrasi_mahasiswa_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES public.semester(id);


--
-- TOC entry 4212 (class 2606 OID 17929)
-- Name: role_has_menus role_has_menus_menus_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_has_menus
    ADD CONSTRAINT role_has_menus_menus_id_fkey FOREIGN KEY (menus_id) REFERENCES public.menus(id);


--
-- TOC entry 4213 (class 2606 OID 17934)
-- Name: role_has_menus role_has_menus_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_has_menus
    ADD CONSTRAINT role_has_menus_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- TOC entry 4214 (class 2606 OID 17939)
-- Name: ruangan ruangan_gedung_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ruangan
    ADD CONSTRAINT ruangan_gedung_id_fkey FOREIGN KEY (gedung_id) REFERENCES public.gedung(id);


--
-- TOC entry 4215 (class 2606 OID 17944)
-- Name: staf staf_jurusan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staf
    ADD CONSTRAINT staf_jurusan_id_fkey FOREIGN KEY (jurusan_id) REFERENCES public.jurusan(id);


--
-- TOC entry 4216 (class 2606 OID 17949)
-- Name: staf staf_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staf
    ADD CONSTRAINT staf_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 4217 (class 2606 OID 17954)
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- TOC entry 4176 (class 2606 OID 17204)
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4177 (class 2606 OID 17251)
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4178 (class 2606 OID 17271)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4179 (class 2606 OID 17266)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- TOC entry 4180 (class 2606 OID 17335)
-- Name: vector_indexes vector_indexes_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_vectors(id);


--
-- TOC entry 4377 (class 0 OID 16529)
-- Dependencies: 311
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4388 (class 0 OID 16889)
-- Dependencies: 324
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4379 (class 0 OID 16686)
-- Dependencies: 315
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4376 (class 0 OID 16522)
-- Dependencies: 310
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4383 (class 0 OID 16776)
-- Dependencies: 319
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4382 (class 0 OID 16764)
-- Dependencies: 318
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4381 (class 0 OID 16751)
-- Dependencies: 317
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4389 (class 0 OID 16939)
-- Dependencies: 325
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4375 (class 0 OID 16511)
-- Dependencies: 309
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4386 (class 0 OID 16818)
-- Dependencies: 322
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4387 (class 0 OID 16836)
-- Dependencies: 323
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4378 (class 0 OID 16537)
-- Dependencies: 312
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4380 (class 0 OID 16716)
-- Dependencies: 316
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4385 (class 0 OID 16803)
-- Dependencies: 321
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4384 (class 0 OID 16794)
-- Dependencies: 320
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4374 (class 0 OID 16499)
-- Dependencies: 307
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4398 (class 0 OID 17523)
-- Dependencies: 347
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4391 (class 0 OID 17183)
-- Dependencies: 335
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4395 (class 0 OID 17302)
-- Dependencies: 339
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4396 (class 0 OID 17315)
-- Dependencies: 340
-- Name: buckets_vectors; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_vectors ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4390 (class 0 OID 17175)
-- Dependencies: 334
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4392 (class 0 OID 17193)
-- Dependencies: 336
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4393 (class 0 OID 17242)
-- Dependencies: 337
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4394 (class 0 OID 17256)
-- Dependencies: 338
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4397 (class 0 OID 17325)
-- Dependencies: 341
-- Name: vector_indexes; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.vector_indexes ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4399 (class 6104 OID 16430)
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- TOC entry 4481 (class 0 OID 0)
-- Dependencies: 26
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT USAGE ON SCHEMA auth TO postgres;


--
-- TOC entry 4482 (class 0 OID 0)
-- Dependencies: 14
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- TOC entry 4483 (class 0 OID 0)
-- Dependencies: 13
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- TOC entry 4484 (class 0 OID 0)
-- Dependencies: 12
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres;
GRANT USAGE ON SCHEMA realtime TO anon;
GRANT USAGE ON SCHEMA realtime TO authenticated;
GRANT USAGE ON SCHEMA realtime TO service_role;
GRANT ALL ON SCHEMA realtime TO supabase_realtime_admin;


--
-- TOC entry 4485 (class 0 OID 0)
-- Dependencies: 27
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA storage TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- TOC entry 4486 (class 0 OID 0)
-- Dependencies: 21
-- Name: SCHEMA vault; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA vault TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA vault TO service_role;


--
-- TOC entry 4492 (class 0 OID 0)
-- Dependencies: 456
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;


--
-- TOC entry 4493 (class 0 OID 0)
-- Dependencies: 469
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- TOC entry 4495 (class 0 OID 0)
-- Dependencies: 455
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;


--
-- TOC entry 4497 (class 0 OID 0)
-- Dependencies: 454
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;


--
-- TOC entry 4498 (class 0 OID 0)
-- Dependencies: 450
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;


--
-- TOC entry 4499 (class 0 OID 0)
-- Dependencies: 451
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea, text[], text[]) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;


--
-- TOC entry 4500 (class 0 OID 0)
-- Dependencies: 422
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.crypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;


--
-- TOC entry 4501 (class 0 OID 0)
-- Dependencies: 452
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.dearmor(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;


--
-- TOC entry 4502 (class 0 OID 0)
-- Dependencies: 426
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 4503 (class 0 OID 0)
-- Dependencies: 428
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 4504 (class 0 OID 0)
-- Dependencies: 419
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;


--
-- TOC entry 4505 (class 0 OID 0)
-- Dependencies: 418
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;


--
-- TOC entry 4506 (class 0 OID 0)
-- Dependencies: 425
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 4507 (class 0 OID 0)
-- Dependencies: 427
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 4508 (class 0 OID 0)
-- Dependencies: 429
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_bytes(integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;


--
-- TOC entry 4509 (class 0 OID 0)
-- Dependencies: 430
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_uuid() FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;


--
-- TOC entry 4510 (class 0 OID 0)
-- Dependencies: 423
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;


--
-- TOC entry 4511 (class 0 OID 0)
-- Dependencies: 424
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text, integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;


--
-- TOC entry 4513 (class 0 OID 0)
-- Dependencies: 457
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_cron_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- TOC entry 4515 (class 0 OID 0)
-- Dependencies: 461
-- Name: FUNCTION grant_pg_graphql_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.grant_pg_graphql_access() TO postgres WITH GRANT OPTION;


--
-- TOC entry 4517 (class 0 OID 0)
-- Dependencies: 458
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_net_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- TOC entry 4518 (class 0 OID 0)
-- Dependencies: 421
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 4519 (class 0 OID 0)
-- Dependencies: 420
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;


--
-- TOC entry 4520 (class 0 OID 0)
-- Dependencies: 406
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO dashboard_user;


--
-- TOC entry 4521 (class 0 OID 0)
-- Dependencies: 405
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO dashboard_user;


--
-- TOC entry 4522 (class 0 OID 0)
-- Dependencies: 407
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO dashboard_user;


--
-- TOC entry 4523 (class 0 OID 0)
-- Dependencies: 453
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;


--
-- TOC entry 4524 (class 0 OID 0)
-- Dependencies: 449
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_key_id(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;


--
-- TOC entry 4525 (class 0 OID 0)
-- Dependencies: 443
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;


--
-- TOC entry 4526 (class 0 OID 0)
-- Dependencies: 445
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 4527 (class 0 OID 0)
-- Dependencies: 447
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;


--
-- TOC entry 4528 (class 0 OID 0)
-- Dependencies: 444
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- TOC entry 4529 (class 0 OID 0)
-- Dependencies: 446
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 4530 (class 0 OID 0)
-- Dependencies: 448
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;


--
-- TOC entry 4531 (class 0 OID 0)
-- Dependencies: 439
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;


--
-- TOC entry 4532 (class 0 OID 0)
-- Dependencies: 441
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;


--
-- TOC entry 4533 (class 0 OID 0)
-- Dependencies: 440
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- TOC entry 4534 (class 0 OID 0)
-- Dependencies: 442
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 4535 (class 0 OID 0)
-- Dependencies: 435
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;


--
-- TOC entry 4536 (class 0 OID 0)
-- Dependencies: 437
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;


--
-- TOC entry 4537 (class 0 OID 0)
-- Dependencies: 436
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;


--
-- TOC entry 4538 (class 0 OID 0)
-- Dependencies: 438
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- TOC entry 4539 (class 0 OID 0)
-- Dependencies: 431
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;


--
-- TOC entry 4540 (class 0 OID 0)
-- Dependencies: 433
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;


--
-- TOC entry 4541 (class 0 OID 0)
-- Dependencies: 432
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;


--
-- TOC entry 4542 (class 0 OID 0)
-- Dependencies: 434
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- TOC entry 4543 (class 0 OID 0)
-- Dependencies: 459
-- Name: FUNCTION pgrst_ddl_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_ddl_watch() TO postgres WITH GRANT OPTION;


--
-- TOC entry 4544 (class 0 OID 0)
-- Dependencies: 460
-- Name: FUNCTION pgrst_drop_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_drop_watch() TO postgres WITH GRANT OPTION;


--
-- TOC entry 4546 (class 0 OID 0)
-- Dependencies: 462
-- Name: FUNCTION set_graphql_placeholder(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.set_graphql_placeholder() TO postgres WITH GRANT OPTION;


--
-- TOC entry 4547 (class 0 OID 0)
-- Dependencies: 413
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;


--
-- TOC entry 4548 (class 0 OID 0)
-- Dependencies: 414
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1mc() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;


--
-- TOC entry 4549 (class 0 OID 0)
-- Dependencies: 415
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;


--
-- TOC entry 4550 (class 0 OID 0)
-- Dependencies: 416
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v4() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;


--
-- TOC entry 4551 (class 0 OID 0)
-- Dependencies: 417
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;


--
-- TOC entry 4552 (class 0 OID 0)
-- Dependencies: 408
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_nil() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;


--
-- TOC entry 4553 (class 0 OID 0)
-- Dependencies: 409
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_dns() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;


--
-- TOC entry 4554 (class 0 OID 0)
-- Dependencies: 411
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_oid() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;


--
-- TOC entry 4555 (class 0 OID 0)
-- Dependencies: 410
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_url() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;


--
-- TOC entry 4556 (class 0 OID 0)
-- Dependencies: 412
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_x500() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;


--
-- TOC entry 4557 (class 0 OID 0)
-- Dependencies: 468
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- TOC entry 4558 (class 0 OID 0)
-- Dependencies: 392
-- Name: FUNCTION pg_reload_conf(); Type: ACL; Schema: pg_catalog; Owner: supabase_admin
--

GRANT ALL ON FUNCTION pg_catalog.pg_reload_conf() TO postgres WITH GRANT OPTION;


--
-- TOC entry 4559 (class 0 OID 0)
-- Dependencies: 404
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;


--
-- TOC entry 4560 (class 0 OID 0)
-- Dependencies: 492
-- Name: FUNCTION apply_rls(wal jsonb, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO supabase_realtime_admin;


--
-- TOC entry 4561 (class 0 OID 0)
-- Dependencies: 497
-- Name: FUNCTION broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO postgres;
GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO dashboard_user;


--
-- TOC entry 4562 (class 0 OID 0)
-- Dependencies: 494
-- Name: FUNCTION build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO postgres;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO anon;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO service_role;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO supabase_realtime_admin;


--
-- TOC entry 4563 (class 0 OID 0)
-- Dependencies: 490
-- Name: FUNCTION "cast"(val text, type_ regtype); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO postgres;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO dashboard_user;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO anon;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO authenticated;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO service_role;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO supabase_realtime_admin;


--
-- TOC entry 4564 (class 0 OID 0)
-- Dependencies: 489
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO service_role;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO supabase_realtime_admin;


--
-- TOC entry 4565 (class 0 OID 0)
-- Dependencies: 493
-- Name: FUNCTION is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO postgres;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO anon;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO service_role;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO supabase_realtime_admin;


--
-- TOC entry 4566 (class 0 OID 0)
-- Dependencies: 499
-- Name: FUNCTION list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO dashboard_user;


--
-- TOC entry 4567 (class 0 OID 0)
-- Dependencies: 488
-- Name: FUNCTION quote_wal2json(entity regclass); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO postgres;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO anon;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO authenticated;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO service_role;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO supabase_realtime_admin;


--
-- TOC entry 4568 (class 0 OID 0)
-- Dependencies: 496
-- Name: FUNCTION send(payload jsonb, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO dashboard_user;


--
-- TOC entry 4569 (class 0 OID 0)
-- Dependencies: 500
-- Name: FUNCTION send_binary(payload bytea, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.send_binary(payload bytea, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send_binary(payload bytea, event text, topic text, private boolean) TO dashboard_user;


--
-- TOC entry 4570 (class 0 OID 0)
-- Dependencies: 487
-- Name: FUNCTION subscription_check_filters(); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO postgres;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO dashboard_user;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO anon;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO authenticated;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO service_role;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO supabase_realtime_admin;


--
-- TOC entry 4571 (class 0 OID 0)
-- Dependencies: 491
-- Name: FUNCTION to_regrole(role_name text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO postgres;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO anon;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO authenticated;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO service_role;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO supabase_realtime_admin;


--
-- TOC entry 4572 (class 0 OID 0)
-- Dependencies: 495
-- Name: FUNCTION topic(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.topic() TO postgres;
GRANT ALL ON FUNCTION realtime.topic() TO dashboard_user;


--
-- TOC entry 4573 (class 0 OID 0)
-- Dependencies: 498
-- Name: FUNCTION wal2json_escape_identifier(name text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.wal2json_escape_identifier(name text) TO postgres;
GRANT ALL ON FUNCTION realtime.wal2json_escape_identifier(name text) TO dashboard_user;


--
-- TOC entry 4574 (class 0 OID 0)
-- Dependencies: 464
-- Name: FUNCTION _crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO service_role;


--
-- TOC entry 4575 (class 0 OID 0)
-- Dependencies: 466
-- Name: FUNCTION create_secret(new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- TOC entry 4576 (class 0 OID 0)
-- Dependencies: 467
-- Name: FUNCTION update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- TOC entry 4578 (class 0 OID 0)
-- Dependencies: 311
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.audit_log_entries TO postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO postgres WITH GRANT OPTION;


--
-- TOC entry 4579 (class 0 OID 0)
-- Dependencies: 330
-- Name: TABLE custom_oauth_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.custom_oauth_providers TO postgres;
GRANT ALL ON TABLE auth.custom_oauth_providers TO dashboard_user;


--
-- TOC entry 4581 (class 0 OID 0)
-- Dependencies: 324
-- Name: TABLE flow_state; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.flow_state TO postgres;
GRANT SELECT ON TABLE auth.flow_state TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.flow_state TO dashboard_user;


--
-- TOC entry 4584 (class 0 OID 0)
-- Dependencies: 315
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.identities TO postgres;
GRANT SELECT ON TABLE auth.identities TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.identities TO dashboard_user;


--
-- TOC entry 4586 (class 0 OID 0)
-- Dependencies: 310
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.instances TO postgres;
GRANT SELECT ON TABLE auth.instances TO postgres WITH GRANT OPTION;


--
-- TOC entry 4588 (class 0 OID 0)
-- Dependencies: 319
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_amr_claims TO postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- TOC entry 4590 (class 0 OID 0)
-- Dependencies: 318
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_challenges TO postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- TOC entry 4593 (class 0 OID 0)
-- Dependencies: 317
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_factors TO postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;


--
-- TOC entry 4594 (class 0 OID 0)
-- Dependencies: 327
-- Name: TABLE oauth_authorizations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_authorizations TO postgres;
GRANT ALL ON TABLE auth.oauth_authorizations TO dashboard_user;


--
-- TOC entry 4596 (class 0 OID 0)
-- Dependencies: 329
-- Name: TABLE oauth_client_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_client_states TO postgres;
GRANT ALL ON TABLE auth.oauth_client_states TO dashboard_user;


--
-- TOC entry 4597 (class 0 OID 0)
-- Dependencies: 326
-- Name: TABLE oauth_clients; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_clients TO postgres;
GRANT ALL ON TABLE auth.oauth_clients TO dashboard_user;


--
-- TOC entry 4598 (class 0 OID 0)
-- Dependencies: 328
-- Name: TABLE oauth_consents; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_consents TO postgres;
GRANT ALL ON TABLE auth.oauth_consents TO dashboard_user;


--
-- TOC entry 4599 (class 0 OID 0)
-- Dependencies: 325
-- Name: TABLE one_time_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.one_time_tokens TO postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.one_time_tokens TO dashboard_user;


--
-- TOC entry 4601 (class 0 OID 0)
-- Dependencies: 309
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.refresh_tokens TO postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO postgres WITH GRANT OPTION;


--
-- TOC entry 4603 (class 0 OID 0)
-- Dependencies: 308
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- TOC entry 4605 (class 0 OID 0)
-- Dependencies: 322
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_providers TO postgres;
GRANT SELECT ON TABLE auth.saml_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_providers TO dashboard_user;


--
-- TOC entry 4607 (class 0 OID 0)
-- Dependencies: 323
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_relay_states TO postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;


--
-- TOC entry 4609 (class 0 OID 0)
-- Dependencies: 312
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT SELECT ON TABLE auth.schema_migrations TO postgres WITH GRANT OPTION;


--
-- TOC entry 4614 (class 0 OID 0)
-- Dependencies: 316
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sessions TO postgres;
GRANT SELECT ON TABLE auth.sessions TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;


--
-- TOC entry 4616 (class 0 OID 0)
-- Dependencies: 321
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_domains TO postgres;
GRANT SELECT ON TABLE auth.sso_domains TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;


--
-- TOC entry 4619 (class 0 OID 0)
-- Dependencies: 320
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_providers TO postgres;
GRANT SELECT ON TABLE auth.sso_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;


--
-- TOC entry 4622 (class 0 OID 0)
-- Dependencies: 307
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.users TO postgres;
GRANT SELECT ON TABLE auth.users TO postgres WITH GRANT OPTION;


--
-- TOC entry 4623 (class 0 OID 0)
-- Dependencies: 332
-- Name: TABLE webauthn_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.webauthn_challenges TO postgres;
GRANT ALL ON TABLE auth.webauthn_challenges TO dashboard_user;


--
-- TOC entry 4624 (class 0 OID 0)
-- Dependencies: 331
-- Name: TABLE webauthn_credentials; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.webauthn_credentials TO postgres;
GRANT ALL ON TABLE auth.webauthn_credentials TO dashboard_user;


--
-- TOC entry 4625 (class 0 OID 0)
-- Dependencies: 306
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements TO dashboard_user;


--
-- TOC entry 4626 (class 0 OID 0)
-- Dependencies: 305
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements_info FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO dashboard_user;


--
-- TOC entry 4627 (class 0 OID 0)
-- Dependencies: 348
-- Name: TABLE daftar_pekerjaan; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.daftar_pekerjaan TO anon;
GRANT ALL ON TABLE public.daftar_pekerjaan TO authenticated;
GRANT ALL ON TABLE public.daftar_pekerjaan TO service_role;


--
-- TOC entry 4628 (class 0 OID 0)
-- Dependencies: 349
-- Name: SEQUENCE daftar_pekerjaan_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.daftar_pekerjaan_id_seq TO anon;
GRANT ALL ON SEQUENCE public.daftar_pekerjaan_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.daftar_pekerjaan_id_seq TO service_role;


--
-- TOC entry 4629 (class 0 OID 0)
-- Dependencies: 350
-- Name: TABLE ekuivalensi_kelas; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.ekuivalensi_kelas TO anon;
GRANT ALL ON TABLE public.ekuivalensi_kelas TO authenticated;
GRANT ALL ON TABLE public.ekuivalensi_kelas TO service_role;


--
-- TOC entry 4630 (class 0 OID 0)
-- Dependencies: 351
-- Name: SEQUENCE ekuivalensi_kelas_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.ekuivalensi_kelas_id_seq TO anon;
GRANT ALL ON SEQUENCE public.ekuivalensi_kelas_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.ekuivalensi_kelas_id_seq TO service_role;


--
-- TOC entry 4631 (class 0 OID 0)
-- Dependencies: 352
-- Name: TABLE gedung; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.gedung TO anon;
GRANT ALL ON TABLE public.gedung TO authenticated;
GRANT ALL ON TABLE public.gedung TO service_role;


--
-- TOC entry 4632 (class 0 OID 0)
-- Dependencies: 353
-- Name: SEQUENCE gedung_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.gedung_id_seq TO anon;
GRANT ALL ON SEQUENCE public.gedung_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.gedung_id_seq TO service_role;


--
-- TOC entry 4633 (class 0 OID 0)
-- Dependencies: 354
-- Name: TABLE import_log; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.import_log TO anon;
GRANT ALL ON TABLE public.import_log TO authenticated;
GRANT ALL ON TABLE public.import_log TO service_role;


--
-- TOC entry 4634 (class 0 OID 0)
-- Dependencies: 355
-- Name: SEQUENCE import_log_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.import_log_id_seq TO anon;
GRANT ALL ON SEQUENCE public.import_log_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.import_log_id_seq TO service_role;


--
-- TOC entry 4635 (class 0 OID 0)
-- Dependencies: 356
-- Name: TABLE jurusan; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.jurusan TO anon;
GRANT ALL ON TABLE public.jurusan TO authenticated;
GRANT ALL ON TABLE public.jurusan TO service_role;


--
-- TOC entry 4636 (class 0 OID 0)
-- Dependencies: 357
-- Name: SEQUENCE jurusan_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.jurusan_id_seq TO anon;
GRANT ALL ON SEQUENCE public.jurusan_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.jurusan_id_seq TO service_role;


--
-- TOC entry 4637 (class 0 OID 0)
-- Dependencies: 358
-- Name: TABLE kelas; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.kelas TO anon;
GRANT ALL ON TABLE public.kelas TO authenticated;
GRANT ALL ON TABLE public.kelas TO service_role;


--
-- TOC entry 4638 (class 0 OID 0)
-- Dependencies: 359
-- Name: SEQUENCE kelas_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.kelas_id_seq TO anon;
GRANT ALL ON SEQUENCE public.kelas_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.kelas_id_seq TO service_role;


--
-- TOC entry 4639 (class 0 OID 0)
-- Dependencies: 360
-- Name: TABLE kompen_awal; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.kompen_awal TO anon;
GRANT ALL ON TABLE public.kompen_awal TO authenticated;
GRANT ALL ON TABLE public.kompen_awal TO service_role;


--
-- TOC entry 4640 (class 0 OID 0)
-- Dependencies: 361
-- Name: SEQUENCE kompen_awal_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.kompen_awal_id_seq TO anon;
GRANT ALL ON SEQUENCE public.kompen_awal_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.kompen_awal_id_seq TO service_role;


--
-- TOC entry 4641 (class 0 OID 0)
-- Dependencies: 362
-- Name: TABLE log_potong_jam; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.log_potong_jam TO anon;
GRANT ALL ON TABLE public.log_potong_jam TO authenticated;
GRANT ALL ON TABLE public.log_potong_jam TO service_role;


--
-- TOC entry 4642 (class 0 OID 0)
-- Dependencies: 363
-- Name: SEQUENCE log_potong_jam_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.log_potong_jam_id_seq TO anon;
GRANT ALL ON SEQUENCE public.log_potong_jam_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.log_potong_jam_id_seq TO service_role;


--
-- TOC entry 4643 (class 0 OID 0)
-- Dependencies: 364
-- Name: TABLE mahasiswa; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.mahasiswa TO anon;
GRANT ALL ON TABLE public.mahasiswa TO authenticated;
GRANT ALL ON TABLE public.mahasiswa TO service_role;


--
-- TOC entry 4644 (class 0 OID 0)
-- Dependencies: 365
-- Name: TABLE menus; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.menus TO anon;
GRANT ALL ON TABLE public.menus TO authenticated;
GRANT ALL ON TABLE public.menus TO service_role;


--
-- TOC entry 4645 (class 0 OID 0)
-- Dependencies: 366
-- Name: SEQUENCE menus_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.menus_id_seq TO anon;
GRANT ALL ON SEQUENCE public.menus_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.menus_id_seq TO service_role;


--
-- TOC entry 4646 (class 0 OID 0)
-- Dependencies: 367
-- Name: TABLE pengaturan_sistem; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.pengaturan_sistem TO anon;
GRANT ALL ON TABLE public.pengaturan_sistem TO authenticated;
GRANT ALL ON TABLE public.pengaturan_sistem TO service_role;


--
-- TOC entry 4647 (class 0 OID 0)
-- Dependencies: 368
-- Name: SEQUENCE pengaturan_sistem_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.pengaturan_sistem_id_seq TO anon;
GRANT ALL ON SEQUENCE public.pengaturan_sistem_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.pengaturan_sistem_id_seq TO service_role;


--
-- TOC entry 4648 (class 0 OID 0)
-- Dependencies: 369
-- Name: TABLE penugasan; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.penugasan TO anon;
GRANT ALL ON TABLE public.penugasan TO authenticated;
GRANT ALL ON TABLE public.penugasan TO service_role;


--
-- TOC entry 4649 (class 0 OID 0)
-- Dependencies: 370
-- Name: SEQUENCE penugasan_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.penugasan_id_seq TO anon;
GRANT ALL ON SEQUENCE public.penugasan_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.penugasan_id_seq TO service_role;


--
-- TOC entry 4650 (class 0 OID 0)
-- Dependencies: 371
-- Name: TABLE prodi; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.prodi TO anon;
GRANT ALL ON TABLE public.prodi TO authenticated;
GRANT ALL ON TABLE public.prodi TO service_role;


--
-- TOC entry 4651 (class 0 OID 0)
-- Dependencies: 372
-- Name: SEQUENCE prodi_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.prodi_id_seq TO anon;
GRANT ALL ON SEQUENCE public.prodi_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.prodi_id_seq TO service_role;


--
-- TOC entry 4652 (class 0 OID 0)
-- Dependencies: 373
-- Name: TABLE ref_status_ekuivalensi; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.ref_status_ekuivalensi TO anon;
GRANT ALL ON TABLE public.ref_status_ekuivalensi TO authenticated;
GRANT ALL ON TABLE public.ref_status_ekuivalensi TO service_role;


--
-- TOC entry 4653 (class 0 OID 0)
-- Dependencies: 374
-- Name: TABLE ref_status_import; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.ref_status_import TO anon;
GRANT ALL ON TABLE public.ref_status_import TO authenticated;
GRANT ALL ON TABLE public.ref_status_import TO service_role;


--
-- TOC entry 4654 (class 0 OID 0)
-- Dependencies: 375
-- Name: TABLE ref_status_tugas; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.ref_status_tugas TO anon;
GRANT ALL ON TABLE public.ref_status_tugas TO authenticated;
GRANT ALL ON TABLE public.ref_status_tugas TO service_role;


--
-- TOC entry 4655 (class 0 OID 0)
-- Dependencies: 376
-- Name: TABLE ref_tipe_pekerjaan; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.ref_tipe_pekerjaan TO anon;
GRANT ALL ON TABLE public.ref_tipe_pekerjaan TO authenticated;
GRANT ALL ON TABLE public.ref_tipe_pekerjaan TO service_role;


--
-- TOC entry 4656 (class 0 OID 0)
-- Dependencies: 377
-- Name: TABLE registrasi_mahasiswa; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.registrasi_mahasiswa TO anon;
GRANT ALL ON TABLE public.registrasi_mahasiswa TO authenticated;
GRANT ALL ON TABLE public.registrasi_mahasiswa TO service_role;


--
-- TOC entry 4657 (class 0 OID 0)
-- Dependencies: 378
-- Name: SEQUENCE registrasi_mahasiswa_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.registrasi_mahasiswa_id_seq TO anon;
GRANT ALL ON SEQUENCE public.registrasi_mahasiswa_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.registrasi_mahasiswa_id_seq TO service_role;


--
-- TOC entry 4658 (class 0 OID 0)
-- Dependencies: 379
-- Name: TABLE role_has_menus; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.role_has_menus TO anon;
GRANT ALL ON TABLE public.role_has_menus TO authenticated;
GRANT ALL ON TABLE public.role_has_menus TO service_role;


--
-- TOC entry 4659 (class 0 OID 0)
-- Dependencies: 380
-- Name: SEQUENCE role_has_menus_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.role_has_menus_id_seq TO anon;
GRANT ALL ON SEQUENCE public.role_has_menus_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.role_has_menus_id_seq TO service_role;


--
-- TOC entry 4660 (class 0 OID 0)
-- Dependencies: 381
-- Name: TABLE roles; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.roles TO anon;
GRANT ALL ON TABLE public.roles TO authenticated;
GRANT ALL ON TABLE public.roles TO service_role;


--
-- TOC entry 4661 (class 0 OID 0)
-- Dependencies: 382
-- Name: TABLE ruangan; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.ruangan TO anon;
GRANT ALL ON TABLE public.ruangan TO authenticated;
GRANT ALL ON TABLE public.ruangan TO service_role;


--
-- TOC entry 4662 (class 0 OID 0)
-- Dependencies: 383
-- Name: SEQUENCE ruangan_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.ruangan_id_seq TO anon;
GRANT ALL ON SEQUENCE public.ruangan_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.ruangan_id_seq TO service_role;


--
-- TOC entry 4663 (class 0 OID 0)
-- Dependencies: 384
-- Name: TABLE semester; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.semester TO anon;
GRANT ALL ON TABLE public.semester TO authenticated;
GRANT ALL ON TABLE public.semester TO service_role;


--
-- TOC entry 4664 (class 0 OID 0)
-- Dependencies: 385
-- Name: SEQUENCE semester_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.semester_id_seq TO anon;
GRANT ALL ON SEQUENCE public.semester_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.semester_id_seq TO service_role;


--
-- TOC entry 4665 (class 0 OID 0)
-- Dependencies: 386
-- Name: TABLE staf; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.staf TO anon;
GRANT ALL ON TABLE public.staf TO authenticated;
GRANT ALL ON TABLE public.staf TO service_role;


--
-- TOC entry 4666 (class 0 OID 0)
-- Dependencies: 387
-- Name: TABLE users; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.users TO anon;
GRANT ALL ON TABLE public.users TO authenticated;
GRANT ALL ON TABLE public.users TO service_role;


--
-- TOC entry 4667 (class 0 OID 0)
-- Dependencies: 388
-- Name: SEQUENCE users_user_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.users_user_id_seq TO anon;
GRANT ALL ON SEQUENCE public.users_user_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.users_user_id_seq TO service_role;


--
-- TOC entry 4668 (class 0 OID 0)
-- Dependencies: 389
-- Name: TABLE v_mahasiswa_aktif; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_mahasiswa_aktif TO anon;
GRANT ALL ON TABLE public.v_mahasiswa_aktif TO authenticated;
GRANT ALL ON TABLE public.v_mahasiswa_aktif TO service_role;


--
-- TOC entry 4669 (class 0 OID 0)
-- Dependencies: 390
-- Name: TABLE v_sisa_kompen; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_sisa_kompen TO anon;
GRANT ALL ON TABLE public.v_sisa_kompen TO authenticated;
GRANT ALL ON TABLE public.v_sisa_kompen TO service_role;


--
-- TOC entry 4670 (class 0 OID 0)
-- Dependencies: 391
-- Name: TABLE v_status_pekerjaan; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_status_pekerjaan TO anon;
GRANT ALL ON TABLE public.v_status_pekerjaan TO authenticated;
GRANT ALL ON TABLE public.v_status_pekerjaan TO service_role;


--
-- TOC entry 4671 (class 0 OID 0)
-- Dependencies: 347
-- Name: TABLE messages; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages TO postgres;
GRANT ALL ON TABLE realtime.messages TO dashboard_user;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO anon;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO authenticated;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO service_role;


--
-- TOC entry 4672 (class 0 OID 0)
-- Dependencies: 333
-- Name: TABLE schema_migrations; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.schema_migrations TO postgres;
GRANT ALL ON TABLE realtime.schema_migrations TO dashboard_user;
GRANT SELECT ON TABLE realtime.schema_migrations TO anon;
GRANT SELECT ON TABLE realtime.schema_migrations TO authenticated;
GRANT SELECT ON TABLE realtime.schema_migrations TO service_role;
GRANT ALL ON TABLE realtime.schema_migrations TO supabase_realtime_admin;


--
-- TOC entry 4673 (class 0 OID 0)
-- Dependencies: 344
-- Name: TABLE subscription; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.subscription TO postgres;
GRANT ALL ON TABLE realtime.subscription TO dashboard_user;
GRANT SELECT ON TABLE realtime.subscription TO anon;
GRANT SELECT ON TABLE realtime.subscription TO authenticated;
GRANT SELECT ON TABLE realtime.subscription TO service_role;
GRANT ALL ON TABLE realtime.subscription TO supabase_realtime_admin;


--
-- TOC entry 4674 (class 0 OID 0)
-- Dependencies: 343
-- Name: SEQUENCE subscription_id_seq; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO postgres;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO dashboard_user;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO anon;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO authenticated;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO service_role;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO supabase_realtime_admin;


--
-- TOC entry 4676 (class 0 OID 0)
-- Dependencies: 335
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON TABLE storage.buckets FROM supabase_storage_admin;
GRANT ALL ON TABLE storage.buckets TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO postgres WITH GRANT OPTION;


--
-- TOC entry 4677 (class 0 OID 0)
-- Dependencies: 339
-- Name: TABLE buckets_analytics; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets_analytics TO service_role;
GRANT ALL ON TABLE storage.buckets_analytics TO authenticated;
GRANT ALL ON TABLE storage.buckets_analytics TO anon;


--
-- TOC entry 4678 (class 0 OID 0)
-- Dependencies: 340
-- Name: TABLE buckets_vectors; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.buckets_vectors TO service_role;
GRANT SELECT ON TABLE storage.buckets_vectors TO authenticated;
GRANT SELECT ON TABLE storage.buckets_vectors TO anon;


--
-- TOC entry 4680 (class 0 OID 0)
-- Dependencies: 336
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON TABLE storage.objects FROM supabase_storage_admin;
GRANT ALL ON TABLE storage.objects TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO postgres WITH GRANT OPTION;


--
-- TOC entry 4681 (class 0 OID 0)
-- Dependencies: 337
-- Name: TABLE s3_multipart_uploads; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO anon;


--
-- TOC entry 4682 (class 0 OID 0)
-- Dependencies: 338
-- Name: TABLE s3_multipart_uploads_parts; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads_parts TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO anon;


--
-- TOC entry 4683 (class 0 OID 0)
-- Dependencies: 341
-- Name: TABLE vector_indexes; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.vector_indexes TO service_role;
GRANT SELECT ON TABLE storage.vector_indexes TO authenticated;
GRANT SELECT ON TABLE storage.vector_indexes TO anon;


--
-- TOC entry 4684 (class 0 OID 0)
-- Dependencies: 313
-- Name: TABLE secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.secrets TO service_role;


--
-- TOC entry 4685 (class 0 OID 0)
-- Dependencies: 314
-- Name: TABLE decrypted_secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.decrypted_secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.decrypted_secrets TO service_role;


--
-- TOC entry 2558 (class 826 OID 16557)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- TOC entry 2559 (class 826 OID 16558)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- TOC entry 2557 (class 826 OID 16556)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO dashboard_user;


--
-- TOC entry 2568 (class 826 OID 16636)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON SEQUENCES TO postgres WITH GRANT OPTION;


--
-- TOC entry 2567 (class 826 OID 16635)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON FUNCTIONS TO postgres WITH GRANT OPTION;


--
-- TOC entry 2566 (class 826 OID 16634)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON TABLES TO postgres WITH GRANT OPTION;


--
-- TOC entry 2571 (class 826 OID 16591)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO service_role;


--
-- TOC entry 2570 (class 826 OID 16590)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO service_role;


--
-- TOC entry 2569 (class 826 OID 16589)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO service_role;


--
-- TOC entry 2563 (class 826 OID 16571)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO service_role;


--
-- TOC entry 2565 (class 826 OID 16570)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO service_role;


--
-- TOC entry 2564 (class 826 OID 16569)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO service_role;


--
-- TOC entry 2550 (class 826 OID 16494)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- TOC entry 2551 (class 826 OID 16495)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- TOC entry 2549 (class 826 OID 16493)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- TOC entry 2553 (class 826 OID 16497)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- TOC entry 2548 (class 826 OID 16492)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- TOC entry 2552 (class 826 OID 16496)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- TOC entry 2561 (class 826 OID 16561)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- TOC entry 2562 (class 826 OID 16562)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- TOC entry 2560 (class 826 OID 16560)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO dashboard_user;


--
-- TOC entry 2556 (class 826 OID 16550)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO service_role;


--
-- TOC entry 2555 (class 826 OID 16549)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO service_role;


--
-- TOC entry 2554 (class 826 OID 16548)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO service_role;


--
-- TOC entry 3784 (class 3466 OID 16575)
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- TOC entry 3787 (class 3466 OID 16654)
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO supabase_admin;

--
-- TOC entry 3789 (class 3466 OID 16666)
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- TOC entry 3788 (class 3466 OID 16657)
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO supabase_admin;

--
-- TOC entry 3785 (class 3466 OID 16576)
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- TOC entry 3786 (class 3466 OID 16577)
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

-- Completed on 2026-06-15 13:19:51

--
-- PostgreSQL database dump complete
--

\unrestrict bJ2frhPsISr8N68bi9fajnmeqUZLP7P7FK3XtDj8zcs0dWjDfMS8S72D5Pa00dx

