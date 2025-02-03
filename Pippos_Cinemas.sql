--
-- PostgreSQL database dump
--

-- Dumped from database version 12.18 (Ubuntu 12.18-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 16.2

-- Started on 2024-06-03 10:22:08

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 7 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 205 (class 1259 OID 322115)
-- Name: abbonamento; Type: TABLE; Schema: public; Owner: fdiviest
--

CREATE TABLE public.abbonamento (
    codiceabbonamento character varying(6) NOT NULL,
    dataacquisto date NOT NULL,
    prezzo numeric NOT NULL,
    datainizio date NOT NULL,
    datafine date NOT NULL,
    cfcliente character varying(16) NOT NULL,
    CONSTRAINT abbonamento_check CHECK ((datainizio > dataacquisto)),
    CONSTRAINT abbonamento_check1 CHECK ((datafine > datainizio))
);


ALTER TABLE public.abbonamento OWNER TO fdiviest;

--
-- TOC entry 212 (class 1259 OID 322222)
-- Name: biglietto; Type: TABLE; Schema: public; Owner: fdiviest
--

CREATE TABLE public.biglietto (
    codicebiglietto character varying(6) NOT NULL,
    dataacquisto date NOT NULL,
    codiceproiezione character varying(6) NOT NULL,
    cfcliente character varying(16) NOT NULL,
    rigaposto integer,
    colonnaposto integer,
    numerosala integer,
    sedesala character varying(6),
    numeroparcheggio integer,
    sedeparcheggio character varying(6)
);


ALTER TABLE public.biglietto OWNER TO fdiviest;

--
-- TOC entry 202 (class 1259 OID 322089)
-- Name: citta; Type: TABLE; Schema: public; Owner: fdiviest
--

CREATE TABLE public.citta (
    codicecitta character varying(6) NOT NULL,
    nome character varying(50) NOT NULL,
    provincia character varying(2) NOT NULL,
    cap integer NOT NULL
);


ALTER TABLE public.citta OWNER TO fdiviest;

--
-- TOC entry 203 (class 1259 OID 322095)
-- Name: cliente; Type: TABLE; Schema: public; Owner: fdiviest
--

CREATE TABLE public.cliente (
    cf character varying(16) NOT NULL,
    nome character varying(255) NOT NULL,
    cognome character varying(255) NOT NULL,
    datanascita date
);


ALTER TABLE public.cliente OWNER TO fdiviest;

--
-- TOC entry 204 (class 1259 OID 322104)
-- Name: film; Type: TABLE; Schema: public; Owner: fdiviest
--

CREATE TABLE public.film (
    titolo character varying(255) NOT NULL,
    trama character varying(255),
    durata integer,
    rating numeric(2,1),
    annouscita integer,
    CONSTRAINT film_durata_check CHECK ((durata > 0)),
    CONSTRAINT film_rating_check CHECK ((rating >= 0.0))
);


ALTER TABLE public.film OWNER TO fdiviest;

--
-- TOC entry 208 (class 1259 OID 322160)
-- Name: parcheggio; Type: TABLE; Schema: public; Owner: fdiviest
--

CREATE TABLE public.parcheggio (
    numero integer NOT NULL,
    sede character varying(6) NOT NULL,
    prezzo numeric(4,2) NOT NULL,
    tipo character varying(50) NOT NULL,
    CONSTRAINT parcheggio_numero_check CHECK ((numero > 0)),
    CONSTRAINT parcheggio_prezzo_check CHECK ((prezzo >= 0.0)),
    CONSTRAINT parcheggio_tipo_check CHECK (((tipo)::text = ANY ((ARRAY['disabili'::character varying, 'standard'::character varying, 'premium'::character varying])::text[])))
);


ALTER TABLE public.parcheggio OWNER TO fdiviest;

--
-- TOC entry 210 (class 1259 OID 322184)
-- Name: poltrona; Type: TABLE; Schema: public; Owner: fdiviest
--

CREATE TABLE public.poltrona (
    riga integer NOT NULL,
    colonna integer NOT NULL,
    numerosala integer NOT NULL,
    sedesala character varying(6) NOT NULL,
    prezzo numeric NOT NULL,
    tipo character varying(50) NOT NULL,
    CONSTRAINT poltrona_colonna_check CHECK ((colonna > 0)),
    CONSTRAINT poltrona_numerosala_check CHECK ((numerosala > 0)),
    CONSTRAINT poltrona_prezzo_check CHECK ((prezzo >= 0.0)),
    CONSTRAINT poltrona_riga_check CHECK ((riga > 0)),
    CONSTRAINT poltrona_tipo_check CHECK (((tipo)::text = ANY ((ARRAY['disabili'::character varying, 'standard'::character varying, 'premium'::character varying])::text[])))
);


ALTER TABLE public.poltrona OWNER TO fdiviest;

--
-- TOC entry 211 (class 1259 OID 322202)
-- Name: proiezione; Type: TABLE; Schema: public; Owner: fdiviest
--

CREATE TABLE public.proiezione (
    codiceproiezione character varying(6) NOT NULL,
    ora time without time zone NOT NULL,
    data date NOT NULL,
    sededrivein character varying(6),
    numerosala integer,
    sedesala character varying(6),
    titolofilm character varying(255) NOT NULL
);


ALTER TABLE public.proiezione OWNER TO fdiviest;

--
-- TOC entry 209 (class 1259 OID 322173)
-- Name: sala; Type: TABLE; Schema: public; Owner: fdiviest
--

CREATE TABLE public.sala (
    numerosala integer NOT NULL,
    sede character varying(6) NOT NULL,
    CONSTRAINT sala_numerosala_check CHECK ((numerosala > 0))
);


ALTER TABLE public.sala OWNER TO fdiviest;

--
-- TOC entry 207 (class 1259 OID 322145)
-- Name: sede; Type: TABLE; Schema: public; Owner: fdiviest
--

CREATE TABLE public.sede (
    codicesede character varying(6) NOT NULL,
    oraapertura time(0) without time zone,
    orachiusura time(0) without time zone,
    indirizzo character varying(255) NOT NULL,
    codicecitta character varying(6) NOT NULL,
    fatturatototale integer NOT NULL,
    tipo character varying(255) NOT NULL,
    CONSTRAINT sede_tipo_check CHECK (((tipo)::text = ANY ((ARRAY['driveIn'::character varying, 'multisala'::character varying])::text[])))
);


ALTER TABLE public.sede OWNER TO fdiviest;

--
-- TOC entry 206 (class 1259 OID 322130)
-- Name: sottoscrizione; Type: TABLE; Schema: public; Owner: fdiviest
--

CREATE TABLE public.sottoscrizione (
    cfcliente character varying(16) NOT NULL,
    abbonamento character varying(6) NOT NULL,
    datainizioutilizzo date NOT NULL
);


ALTER TABLE public.sottoscrizione OWNER TO fdiviest;

--
-- TOC entry 3022 (class 0 OID 322115)
-- Dependencies: 205
-- Data for Name: abbonamento; Type: TABLE DATA; Schema: public; Owner: fdiviest
--

INSERT INTO public.abbonamento (codiceabbonamento, dataacquisto, prezzo, datainizio, datafine, cfcliente) VALUES ('A00001', '2003-08-02', 100, '2003-09-02', '2003-11-02', 'BLLFPP03M30C111P');
INSERT INTO public.abbonamento (codiceabbonamento, dataacquisto, prezzo, datainizio, datafine, cfcliente) VALUES ('A00002', '2005-02-23', 136.7, '2005-03-23', '2005-04-23', 'RZZPLZ02F11L205R');
INSERT INTO public.abbonamento (codiceabbonamento, dataacquisto, prezzo, datainizio, datafine, cfcliente) VALUES ('A00003', '2011-08-23', 54.99, '2011-10-23', '2011-11-23', 'SRTGLL98B17C351K');


--
-- TOC entry 3029 (class 0 OID 322222)
-- Dependencies: 212
-- Data for Name: biglietto; Type: TABLE DATA; Schema: public; Owner: fdiviest
--

INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00001', '2008-03-21', 'P00001', 'VRDLGI87C30C351P', NULL, NULL, NULL, NULL, 7, 'SD0001');
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00004', '2005-07-21', 'P00002', 'VRDLGI87C30C351P', NULL, NULL, NULL, NULL, 8, 'SD0001');
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00005', '2005-07-21', 'P00002', 'FRNGNN88D10D612F', NULL, NULL, NULL, NULL, 9, 'SD0001');
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00002', '2005-07-21', 'P00002', 'RSSMRA85A01H501Z', NULL, NULL, NULL, NULL, 1, 'SD0001');
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00003', '2005-07-21', 'P00002', 'BNCLRA86B15F205N', NULL, NULL, NULL, NULL, 7, 'SD0001');
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00006', '2005-07-21', 'P00002', 'PLZMRZ89E25B384C', NULL, NULL, NULL, NULL, 11, 'SD0001');
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00007', '2012-05-14', 'P00004', 'MNZMRZ90F05H612X', NULL, NULL, NULL, NULL, 3, 'SD0005');
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00008', '2012-05-14', 'P00004', 'BLDFRC91G18H912K', NULL, NULL, NULL, NULL, 12, 'SD0005');
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00009', '2003-08-19', 'P00005', 'BLDFRC91G18H912K', 1, 1, 1, 'SD0002', NULL, NULL);
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00010', '2003-08-19', 'P00005', 'CLDMRC92H22L912D', 1, 5, 1, 'SD0002', NULL, NULL);
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00011', '2003-08-19', 'P00005', 'RBRLRA93I09E612E', 1, 3, 1, 'SD0002', NULL, NULL);
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00012', '2003-08-19', 'P00005', 'BRTSNS94L13C351Q', 2, 3, 1, 'SD0002', NULL, NULL);
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00013', '2020-12-05', 'P00006', 'GLLMLA95M27C351B', 1, 4, 2, 'SD0002', NULL, NULL);
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00014', '2020-12-05', 'P00006', 'GRNFNC96N03G912Y', 2, 2, 2, 'SD0002', NULL, NULL);
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00015', '2008-04-25', 'P00007', 'BLDFRC91G18H912K', 1, 1, 3, 'SD0002', NULL, NULL);
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00016', '2008-04-25', 'P00007', 'FRNGNN88D10D612F', 2, 2, 3, 'SD0002', NULL, NULL);
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00017', '2008-04-25', 'P00007', 'PLGFRN99C20C351L', 2, 5, 3, 'SD0002', NULL, NULL);
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00018', '2018-02-28', 'P00009', 'GRNFNC96N03G912Y', 2, 2, 2, 'SD0002', NULL, NULL);
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00019', '2018-02-28', 'P00009', 'LCCLUI00D24D205S', 1, 3, 2, 'SD0002', NULL, NULL);
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00020', '2018-02-28', 'P00009', 'PSNMRZ01E29L612N', 2, 4, 2, 'SD0002', NULL, NULL);
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00021', '2022-10-10', 'P00010', 'RZZPLZ02F11L205R', 1, 4, 3, 'SD0002', NULL, NULL);
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00022', '2022-10-10', 'P00010', 'CHLMRC03G23F612G', 1, 5, 3, 'SD0002', NULL, NULL);
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00023', '2022-10-10', 'P00010', 'DVSFPP03M02C111P', 2, 2, 3, 'SD0002', NULL, NULL);
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00024', '2022-10-10', 'P00010', 'BLLFPP03M30C111P', 2, 3, 3, 'SD0002', NULL, NULL);
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00025', '2022-10-10', 'P00010', 'BNZMRZ85M01C205H', 2, 4, 3, 'SD0002', NULL, NULL);
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00026', '2022-10-10', 'P00010', 'GLLMLA95M27C351B', 2, 5, 3, 'SD0002', NULL, NULL);
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00027', '2000-01-01', 'P00011', 'GRNFNC96N03G912Y', 1, 3, 1, 'SD0003', NULL, NULL);
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00028', '2006-06-30', 'P00012', 'MNZMRZ90F05H612X', 1, 1, 2, 'SD0003', NULL, NULL);
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00029', '2006-06-30', 'P00012', 'PLGFRN99C20C351L', 1, 2, 2, 'SD0003', NULL, NULL);
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00030', '2006-06-30', 'P00012', 'CHLMRC03G23F612G', 1, 5, 2, 'SD0003', NULL, NULL);
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00031', '2011-12-11', 'P00013', 'RBRLRA93I09E612E', 1, 5, 3, 'SD0003', NULL, NULL);
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00032', '2011-12-11', 'P00013', 'BNZMRZ85M01C205H', 2, 3, 3, 'SD0003', NULL, NULL);
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00033', '2019-07-17', 'P00015', 'PLZMRZ89E25B384C', 1, 1, 2, 'SD0003', NULL, NULL);
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00034', '2019-07-17', 'P00015', 'MNZMRZ90F05H612X', 1, 5, 2, 'SD0003', NULL, NULL);
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00035', '2019-07-17', 'P00015', 'BLDFRC91G18H912K', 1, 3, 2, 'SD0003', NULL, NULL);
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00036', '2021-09-09', 'P00016', 'CLDMRC92H22L912D', 1, 2, 3, 'SD0003', NULL, NULL);
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00037', '2021-09-09', 'P00016', 'RBRLRA93I09E612E', 2, 3, 3, 'SD0003', NULL, NULL);
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00038', '2021-09-09', 'P00016', 'BRTSNS94L13C351Q', 2, 4, 3, 'SD0003', NULL, NULL);
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00039', '2002-11-23', 'P00017', 'RSSMRA85A01H501Z', 2, 4, 1, 'SD0004', NULL, NULL);
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00040', '2002-11-23', 'P00017', 'MNZMRZ90F05H612X', 2, 3, 1, 'SD0004', NULL, NULL);
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00041', '2009-05-18', 'P00018', 'BNMMLA97A14E205F', 1, 2, 2, 'SD0004', NULL, NULL);
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00042', '2009-05-18', 'P00018', 'DVSFPP03M02C111P', 1, 3, 2, 'SD0004', NULL, NULL);
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00043', '2009-05-18', 'P00018', 'BLLFPP03M30C111P', 1, 4, 2, 'SD0004', NULL, NULL);
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00044', '2009-05-18', 'P00018', 'BRTSNS94L13C351Q', 1, 5, 2, 'SD0004', NULL, NULL);
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00045', '2013-10-29', 'P00019', 'BNZMRZ85M01C205H', 2, 5, 1, 'SD0004', NULL, NULL);
INSERT INTO public.biglietto (codicebiglietto, dataacquisto, codiceproiezione, cfcliente, rigaposto, colonnaposto, numerosala, sedesala, numeroparcheggio, sedeparcheggio) VALUES ('B00046', '2017-08-13', 'P00020', 'VRDLGI87C30C351P', 2, 2, 2, 'SD0004', NULL, NULL);


--
-- TOC entry 3019 (class 0 OID 322089)
-- Dependencies: 202
-- Data for Name: citta; Type: TABLE DATA; Schema: public; Owner: fdiviest
--

INSERT INTO public.citta (codicecitta, nome, provincia, cap) VALUES ('CIT001', 'Roma', 'RM', 12345);
INSERT INTO public.citta (codicecitta, nome, provincia, cap) VALUES ('CIT002', 'Milano', 'MI', 23456);
INSERT INTO public.citta (codicecitta, nome, provincia, cap) VALUES ('CIT003', 'Napoli', 'NA', 34567);
INSERT INTO public.citta (codicecitta, nome, provincia, cap) VALUES ('CIT004', 'Palermo', 'PA', 45678);
INSERT INTO public.citta (codicecitta, nome, provincia, cap) VALUES ('CIT005', 'Genova', 'GE', 56789);
INSERT INTO public.citta (codicecitta, nome, provincia, cap) VALUES ('CIT006', 'Firenze', 'FI', 67890);
INSERT INTO public.citta (codicecitta, nome, provincia, cap) VALUES ('CIT007', 'Bologna', 'BO', 78901);
INSERT INTO public.citta (codicecitta, nome, provincia, cap) VALUES ('CIT008', 'Turin', 'TO', 89012);
INSERT INTO public.citta (codicecitta, nome, provincia, cap) VALUES ('CIT009', 'Venezia', 'VE', 90123);
INSERT INTO public.citta (codicecitta, nome, provincia, cap) VALUES ('CIT012', 'Ravenna', 'RA', 79135);
INSERT INTO public.citta (codicecitta, nome, provincia, cap) VALUES ('CIT014', 'Bari', 'BA', 35791);
INSERT INTO public.citta (codicecitta, nome, provincia, cap) VALUES ('CIT010', 'Trieste', 'TS', 13579);
INSERT INTO public.citta (codicecitta, nome, provincia, cap) VALUES ('CIT011', 'Modena', 'MO', 68024);
INSERT INTO public.citta (codicecitta, nome, provincia, cap) VALUES ('CIT013', 'Perugia', 'PG', 24680);
INSERT INTO public.citta (codicecitta, nome, provincia, cap) VALUES ('CIT015', 'Parma', 'PR', 57913);


--
-- TOC entry 3020 (class 0 OID 322095)
-- Dependencies: 203
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: fdiviest
--

INSERT INTO public.cliente (cf, nome, cognome, datanascita) VALUES ('RSSMRA85A01H501Z', 'Mario', 'Rossi', '1985-01-01');
INSERT INTO public.cliente (cf, nome, cognome, datanascita) VALUES ('BNCLRA86B15F205N', 'Laura', 'Bianchi', '1986-02-15');
INSERT INTO public.cliente (cf, nome, cognome, datanascita) VALUES ('VRDLGI87C30C351P', 'Luigi', 'Verdi', '1987-03-30');
INSERT INTO public.cliente (cf, nome, cognome, datanascita) VALUES ('FRNGNN88D10D612F', 'Gianna', 'Ferrari', '1988-04-10');
INSERT INTO public.cliente (cf, nome, cognome, datanascita) VALUES ('PLZMRZ89E25B384C', 'Maria', 'Pellegrini', '1989-05-25');
INSERT INTO public.cliente (cf, nome, cognome, datanascita) VALUES ('MNZMRZ90F05H612X', 'Marco', 'Manzi', '1990-06-05');
INSERT INTO public.cliente (cf, nome, cognome, datanascita) VALUES ('BLDFRC91G18H912K', 'Francesca', 'Bladi', '1991-07-18');
INSERT INTO public.cliente (cf, nome, cognome, datanascita) VALUES ('CLDMRC92H22L912D', 'Claudio', 'Colombo', '1992-08-22');
INSERT INTO public.cliente (cf, nome, cognome, datanascita) VALUES ('RBRLRA93I09E612E', 'Lara', 'Ruberti', '1993-09-09');
INSERT INTO public.cliente (cf, nome, cognome, datanascita) VALUES ('BRTSNS94L13C351Q', 'Simone', 'Bartolini', '1994-10-13');
INSERT INTO public.cliente (cf, nome, cognome, datanascita) VALUES ('GLLMLA95M27C351B', 'Michele', 'Galante', '1995-11-27');
INSERT INTO public.cliente (cf, nome, cognome, datanascita) VALUES ('GRNFNC96N03G912Y', 'Franco', 'Granata', '1996-12-03');
INSERT INTO public.cliente (cf, nome, cognome, datanascita) VALUES ('BNMMLA97A14E205F', 'Milena', 'Binami', '1997-01-14');
INSERT INTO public.cliente (cf, nome, cognome, datanascita) VALUES ('SRTGLL98B17C351K', 'Gilles', 'Sarti', '1998-02-17');
INSERT INTO public.cliente (cf, nome, cognome, datanascita) VALUES ('PLGFRN99C20C351L', 'Franco', 'Pelagatti', '1999-03-20');
INSERT INTO public.cliente (cf, nome, cognome, datanascita) VALUES ('LCCLUI00D24D205S', 'Luigi', 'Lucchesi', '2000-04-24');
INSERT INTO public.cliente (cf, nome, cognome, datanascita) VALUES ('PSNMRZ01E29L612N', 'Mario', 'Pisano', '2001-05-29');
INSERT INTO public.cliente (cf, nome, cognome, datanascita) VALUES ('RZZPLZ02F11L205R', 'Paolo', 'Razzetti', '2002-06-11');
INSERT INTO public.cliente (cf, nome, cognome, datanascita) VALUES ('CHLMRC03G23F612G', 'Marco', 'Chialli', '2003-07-23');
INSERT INTO public.cliente (cf, nome, cognome, datanascita) VALUES ('DVSFPP03M02C111P', 'Filippo', 'Diviesti', '2003-08-02');
INSERT INTO public.cliente (cf, nome, cognome, datanascita) VALUES ('BLLFPP03M30C111P', 'Filippo', 'Bellon', '2003-08-30');
INSERT INTO public.cliente (cf, nome, cognome, datanascita) VALUES ('BNZMRZ85M01C205H', 'Maria', 'Benazzi', '2004-08-16');


--
-- TOC entry 3021 (class 0 OID 322104)
-- Dependencies: 204
-- Data for Name: film; Type: TABLE DATA; Schema: public; Owner: fdiviest
--

INSERT INTO public.film (titolo, trama, durata, rating, annouscita) VALUES ('Inception', 'Un ladro che ruba segreti attraverso l''uso della tecnologia dei sogni viene incaricato di piantare un''idea nella mente di un CEO.', 148, 4.8, 2010);
INSERT INTO public.film (titolo, trama, durata, rating, annouscita) VALUES ('Matrix', 'Un hacker scopre la vera natura della sua realtà e il suo ruolo nella guerra contro i suoi controllori.', 136, 4.7, 1999);
INSERT INTO public.film (titolo, trama, durata, rating, annouscita) VALUES ('Interstellar', 'Un gruppo di esploratori viaggia attraverso un wormhole nello spazio per cercare una nuova casa per l''umanità.', 169, 4.6, 2014);
INSERT INTO public.film (titolo, trama, durata, rating, annouscita) VALUES ('Il Padrino', 'Il patriarca di una dinastia criminale trasferisce il controllo del suo impero clandestino al figlio riluttante.', 175, 4.9, 1972);
INSERT INTO public.film (titolo, trama, durata, rating, annouscita) VALUES ('Pulp Fiction', 'Le vite di due gangster, un pugile, la moglie di un gangster e due rapinatori si intrecciano in quattro storie di violenza e redenzione.', 154, 4.8, 1994);
INSERT INTO public.film (titolo, trama, durata, rating, annouscita) VALUES ('Il Cavaliere Oscuro', 'Quando il Joker emerge come un nuovo nemico, Batman deve affrontare una delle sue sfide più grandi per proteggere Gotham City.', 152, 4.9, 2008);
INSERT INTO public.film (titolo, trama, durata, rating, annouscita) VALUES ('Fight Club', 'Un impiegato d''ufficio insoddisfatto incontra un sapone, e insieme avviano un club di combattimento sotterraneo.', 139, 4.8, 1999);
INSERT INTO public.film (titolo, trama, durata, rating, annouscita) VALUES ('Forrest Gump', 'La vita straordinaria di un uomo semplice con un cuore puro, che partecipa a eventi significativi della storia americana.', 142, 4.7, 1994);
INSERT INTO public.film (titolo, trama, durata, rating, annouscita) VALUES ('Le Ali della Libertà', 'Due uomini imprigionati si legano in decenni di prigionia, trovando conforto e redenzione attraverso atti di decenza comune.', 142, 4.9, 1994);
INSERT INTO public.film (titolo, trama, durata, rating, annouscita) VALUES ('Il Signore degli Anelli: Il Ritorno del Re', 'Gandalf e Aragorn guidano il mondo degli uomini contro l''esercito di Sauron per distrarre la sua attenzione da Frodo e Sam che si avvicinano al Monte Fato con l''Unico Anello.', 201, 4.8, 2003);
INSERT INTO public.film (titolo, trama, durata, rating, annouscita) VALUES ('Il Re Leone', 'Il giovane leone Simba fugge dal suo regno dopo l''omicidio del padre. Anni dopo, ritorna per riprendersi il trono.', 88, 4.7, 1994);
INSERT INTO public.film (titolo, trama, durata, rating, annouscita) VALUES ('Il Gladiatore', 'Un generale romano tradito viene ridotto in schiavitù e diventa un gladiatore per vendicarsi del nuovo imperatore.', 155, 4.7, 2000);
INSERT INTO public.film (titolo, trama, durata, rating, annouscita) VALUES ('Titanic', 'Una ricca ereditiera e un artista povero si innamorano a bordo del lussuoso R.M.S. Titanic.', 195, 4.6, 1997);
INSERT INTO public.film (titolo, trama, durata, rating, annouscita) VALUES ('The Avengers', 'I supereroi della Marvel si uniscono per salvare la Terra da Loki e il suo esercito alieno.', 143, 4.5, 2012);
INSERT INTO public.film (titolo, trama, durata, rating, annouscita) VALUES ('Guerre Stellari: Episodio IV - Una Nuova Speranza', 'Luke Skywalker si unisce a un cavaliere Jedi, a un arrogante pilota, a un Wookiee e a due droidi per salvare la galassia dall''Impero.', 121, 4.8, 1977);
INSERT INTO public.film (titolo, trama, durata, rating, annouscita) VALUES ('Jurassic Park', 'Un parco a tema con dinosauri clonati diventa un incubo quando le creature scappano dal controllo.', 127, 4.7, 1993);
INSERT INTO public.film (titolo, trama, durata, rating, annouscita) VALUES ('Il Silenzio degli Innocenti', 'Un giovane agente dell''FBI chiede l''aiuto di un brillante ma pericoloso psichiatra incarcerato per catturare un altro serial killer.', 118, 4.8, 1991);
INSERT INTO public.film (titolo, trama, durata, rating, annouscita) VALUES ('Schindler''s List', 'La vera storia di Oskar Schindler, che salvò più di mille ebrei durante l''Olocausto.', 195, 4.9, 1993);
INSERT INTO public.film (titolo, trama, durata, rating, annouscita) VALUES ('Avatar', 'Un ex marine paraplegico viene inviato sul pianeta Pandora e si trova in mezzo a un conflitto tra la sua specie e la popolazione indigena.', 162, 4.7, 2009);
INSERT INTO public.film (titolo, trama, durata, rating, annouscita) VALUES ('Il Miglio Verde', 'La vita delle guardie carcerarie viene sconvolta dall''arrivo di un prigioniero con poteri soprannaturali, condannato per omicidio.', 189, 4.8, 1999);


--
-- TOC entry 3025 (class 0 OID 322160)
-- Dependencies: 208
-- Data for Name: parcheggio; Type: TABLE DATA; Schema: public; Owner: fdiviest
--

INSERT INTO public.parcheggio (numero, sede, prezzo, tipo) VALUES (1, 'SD0001', 11.50, 'disabili');
INSERT INTO public.parcheggio (numero, sede, prezzo, tipo) VALUES (1, 'SD0005', 11.50, 'disabili');
INSERT INTO public.parcheggio (numero, sede, prezzo, tipo) VALUES (2, 'SD0001', 11.50, 'disabili');
INSERT INTO public.parcheggio (numero, sede, prezzo, tipo) VALUES (2, 'SD0005', 11.50, 'disabili');
INSERT INTO public.parcheggio (numero, sede, prezzo, tipo) VALUES (3, 'SD0005', 11.50, 'disabili');
INSERT INTO public.parcheggio (numero, sede, prezzo, tipo) VALUES (3, 'SD0001', 11.50, 'disabili');
INSERT INTO public.parcheggio (numero, sede, prezzo, tipo) VALUES (4, 'SD0005', 11.50, 'disabili');
INSERT INTO public.parcheggio (numero, sede, prezzo, tipo) VALUES (4, 'SD0001', 11.50, 'disabili');
INSERT INTO public.parcheggio (numero, sede, prezzo, tipo) VALUES (5, 'SD0005', 11.50, 'disabili');
INSERT INTO public.parcheggio (numero, sede, prezzo, tipo) VALUES (5, 'SD0001', 11.50, 'disabili');
INSERT INTO public.parcheggio (numero, sede, prezzo, tipo) VALUES (6, 'SD0005', 7.50, 'standard');
INSERT INTO public.parcheggio (numero, sede, prezzo, tipo) VALUES (6, 'SD0001', 7.50, 'standard');
INSERT INTO public.parcheggio (numero, sede, prezzo, tipo) VALUES (7, 'SD0005', 7.50, 'standard');
INSERT INTO public.parcheggio (numero, sede, prezzo, tipo) VALUES (7, 'SD0001', 7.50, 'standard');
INSERT INTO public.parcheggio (numero, sede, prezzo, tipo) VALUES (8, 'SD0001', 7.50, 'standard');
INSERT INTO public.parcheggio (numero, sede, prezzo, tipo) VALUES (8, 'SD0005', 7.50, 'standard');
INSERT INTO public.parcheggio (numero, sede, prezzo, tipo) VALUES (9, 'SD0001', 7.50, 'standard');
INSERT INTO public.parcheggio (numero, sede, prezzo, tipo) VALUES (9, 'SD0005', 7.50, 'standard');
INSERT INTO public.parcheggio (numero, sede, prezzo, tipo) VALUES (10, 'SD0001', 7.50, 'standard');
INSERT INTO public.parcheggio (numero, sede, prezzo, tipo) VALUES (10, 'SD0005', 7.50, 'standard');
INSERT INTO public.parcheggio (numero, sede, prezzo, tipo) VALUES (11, 'SD0001', 9.00, 'premium');
INSERT INTO public.parcheggio (numero, sede, prezzo, tipo) VALUES (11, 'SD0005', 9.00, 'premium');
INSERT INTO public.parcheggio (numero, sede, prezzo, tipo) VALUES (12, 'SD0005', 9.00, 'premium');
INSERT INTO public.parcheggio (numero, sede, prezzo, tipo) VALUES (12, 'SD0001', 9.00, 'premium');
INSERT INTO public.parcheggio (numero, sede, prezzo, tipo) VALUES (13, 'SD0005', 9.00, 'premium');
INSERT INTO public.parcheggio (numero, sede, prezzo, tipo) VALUES (13, 'SD0001', 9.00, 'premium');
INSERT INTO public.parcheggio (numero, sede, prezzo, tipo) VALUES (14, 'SD0001', 9.00, 'premium');
INSERT INTO public.parcheggio (numero, sede, prezzo, tipo) VALUES (14, 'SD0005', 9.00, 'premium');
INSERT INTO public.parcheggio (numero, sede, prezzo, tipo) VALUES (15, 'SD0001', 9.00, 'premium');
INSERT INTO public.parcheggio (numero, sede, prezzo, tipo) VALUES (15, 'SD0005', 9.00, 'premium');


--
-- TOC entry 3027 (class 0 OID 322184)
-- Dependencies: 210
-- Data for Name: poltrona; Type: TABLE DATA; Schema: public; Owner: fdiviest
--

INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 1, 1, 'SD0002', 11.5, 'disabili');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 2, 1, 'SD0002', 7.5, 'standard');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 3, 1, 'SD0002', 7.5, 'standard');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 4, 1, 'SD0002', 7.5, 'standard');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 5, 1, 'SD0002', 11.5, 'disabili');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 1, 1, 'SD0002', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 2, 1, 'SD0002', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 3, 1, 'SD0002', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 4, 1, 'SD0002', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 5, 1, 'SD0002', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 1, 2, 'SD0002', 11.5, 'disabili');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 2, 2, 'SD0002', 7.5, 'standard');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 3, 2, 'SD0002', 7.5, 'standard');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 4, 2, 'SD0002', 7.5, 'standard');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 5, 2, 'SD0002', 11.5, 'disabili');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 1, 2, 'SD0002', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 2, 2, 'SD0002', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 3, 2, 'SD0002', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 4, 2, 'SD0002', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 5, 2, 'SD0002', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 1, 3, 'SD0002', 11.5, 'disabili');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 2, 3, 'SD0002', 7.5, 'standard');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 3, 3, 'SD0002', 7.5, 'standard');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 4, 3, 'SD0002', 7.5, 'standard');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 5, 3, 'SD0002', 11.5, 'disabili');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 1, 3, 'SD0002', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 2, 3, 'SD0002', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 3, 3, 'SD0002', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 4, 3, 'SD0002', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 5, 3, 'SD0002', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 1, 1, 'SD0003', 11.5, 'disabili');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 2, 1, 'SD0003', 7.5, 'standard');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 3, 1, 'SD0003', 7.5, 'standard');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 4, 1, 'SD0003', 7.5, 'standard');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 5, 1, 'SD0003', 11.5, 'disabili');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 1, 1, 'SD0003', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 2, 1, 'SD0003', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 3, 1, 'SD0003', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 4, 1, 'SD0003', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 5, 1, 'SD0003', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 1, 2, 'SD0003', 11.5, 'disabili');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 2, 2, 'SD0003', 7.5, 'standard');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 3, 2, 'SD0003', 7.5, 'standard');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 4, 2, 'SD0003', 7.5, 'standard');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 5, 2, 'SD0003', 11.5, 'disabili');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 1, 2, 'SD0003', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 2, 2, 'SD0003', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 3, 2, 'SD0003', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 4, 2, 'SD0003', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 5, 2, 'SD0003', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 1, 3, 'SD0003', 11.5, 'disabili');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 2, 3, 'SD0003', 7.5, 'standard');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 3, 3, 'SD0003', 7.5, 'standard');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 4, 3, 'SD0003', 7.5, 'standard');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 5, 3, 'SD0003', 11.5, 'disabili');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 1, 3, 'SD0003', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 2, 3, 'SD0003', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 3, 3, 'SD0003', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 4, 3, 'SD0003', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 5, 3, 'SD0003', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 1, 1, 'SD0004', 11.5, 'disabili');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 2, 1, 'SD0004', 7.5, 'standard');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 3, 1, 'SD0004', 7.5, 'standard');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 4, 1, 'SD0004', 7.5, 'standard');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 5, 1, 'SD0004', 11.5, 'disabili');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 1, 1, 'SD0004', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 2, 1, 'SD0004', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 3, 1, 'SD0004', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 4, 1, 'SD0004', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 5, 1, 'SD0004', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 1, 2, 'SD0004', 11.5, 'disabili');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 2, 2, 'SD0004', 7.5, 'standard');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 3, 2, 'SD0004', 7.5, 'standard');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 4, 2, 'SD0004', 7.5, 'standard');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (1, 5, 2, 'SD0004', 11.5, 'disabili');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 1, 2, 'SD0004', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 2, 2, 'SD0004', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 3, 2, 'SD0004', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 4, 2, 'SD0004', 9, 'premium');
INSERT INTO public.poltrona (riga, colonna, numerosala, sedesala, prezzo, tipo) VALUES (2, 5, 2, 'SD0004', 9, 'premium');


--
-- TOC entry 3028 (class 0 OID 322202)
-- Dependencies: 211
-- Data for Name: proiezione; Type: TABLE DATA; Schema: public; Owner: fdiviest
--

INSERT INTO public.proiezione (codiceproiezione, ora, data, sededrivein, numerosala, sedesala, titolofilm) VALUES ('P00001', '17:30:00', '2008-03-21', 'SD0001', NULL, NULL, 'Il Gladiatore');
INSERT INTO public.proiezione (codiceproiezione, ora, data, sededrivein, numerosala, sedesala, titolofilm) VALUES ('P00002', '13:30:00', '2005-07-21', 'SD0001', NULL, NULL, 'Jurassic Park');
INSERT INTO public.proiezione (codiceproiezione, ora, data, sededrivein, numerosala, sedesala, titolofilm) VALUES ('P00003', '14:45:00', '2010-11-30', 'SD0005', NULL, NULL, 'Matrix');
INSERT INTO public.proiezione (codiceproiezione, ora, data, sededrivein, numerosala, sedesala, titolofilm) VALUES ('P00004', '15:00:00', '2012-05-14', 'SD0005', NULL, NULL, 'Titanic');
INSERT INTO public.proiezione (codiceproiezione, ora, data, sededrivein, numerosala, sedesala, titolofilm) VALUES ('P00005', '16:15:00', '2003-08-19', NULL, 1, 'SD0002', 'Il Padrino');
INSERT INTO public.proiezione (codiceproiezione, ora, data, sededrivein, numerosala, sedesala, titolofilm) VALUES ('P00006', '17:30:00', '2020-12-05', NULL, 2, 'SD0002', 'Avatar');
INSERT INTO public.proiezione (codiceproiezione, ora, data, sededrivein, numerosala, sedesala, titolofilm) VALUES ('P00007', '18:45:00', '2008-04-25', NULL, 3, 'SD0002', 'Il Re Leone');
INSERT INTO public.proiezione (codiceproiezione, ora, data, sededrivein, numerosala, sedesala, titolofilm) VALUES ('P00008', '19:00:00', '2015-09-07', NULL, 1, 'SD0002', 'Matrix');
INSERT INTO public.proiezione (codiceproiezione, ora, data, sededrivein, numerosala, sedesala, titolofilm) VALUES ('P00009', '20:15:00', '2018-02-28', NULL, 2, 'SD0002', 'Interstellar');
INSERT INTO public.proiezione (codiceproiezione, ora, data, sededrivein, numerosala, sedesala, titolofilm) VALUES ('P00010', '21:30:00', '2022-10-10', NULL, 3, 'SD0002', 'Inception');
INSERT INTO public.proiezione (codiceproiezione, ora, data, sededrivein, numerosala, sedesala, titolofilm) VALUES ('P00011', '22:45:00', '2000-01-01', NULL, 1, 'SD0003', 'Pulp Fiction');
INSERT INTO public.proiezione (codiceproiezione, ora, data, sededrivein, numerosala, sedesala, titolofilm) VALUES ('P00012', '23:00:00', '2006-06-30', NULL, 2, 'SD0003', 'Avatar');
INSERT INTO public.proiezione (codiceproiezione, ora, data, sededrivein, numerosala, sedesala, titolofilm) VALUES ('P00013', '12:30:00', '2011-12-11', NULL, 3, 'SD0003', 'Il Cavaliere Oscuro');
INSERT INTO public.proiezione (codiceproiezione, ora, data, sededrivein, numerosala, sedesala, titolofilm) VALUES ('P00014', '13:45:00', '2016-03-22', NULL, 1, 'SD0003', 'Interstellar');
INSERT INTO public.proiezione (codiceproiezione, ora, data, sededrivein, numerosala, sedesala, titolofilm) VALUES ('P00015', '14:00:00', '2019-07-17', NULL, 2, 'SD0003', 'The Avengers');
INSERT INTO public.proiezione (codiceproiezione, ora, data, sededrivein, numerosala, sedesala, titolofilm) VALUES ('P00016', '15:15:00', '2021-09-09', NULL, 3, 'SD0003', 'Forrest Gump');
INSERT INTO public.proiezione (codiceproiezione, ora, data, sededrivein, numerosala, sedesala, titolofilm) VALUES ('P00017', '16:30:00', '2002-11-23', NULL, 1, 'SD0004', 'Il Re Leone');
INSERT INTO public.proiezione (codiceproiezione, ora, data, sededrivein, numerosala, sedesala, titolofilm) VALUES ('P00018', '17:45:00', '2009-05-18', NULL, 2, 'SD0004', 'Il Gladiatore');
INSERT INTO public.proiezione (codiceproiezione, ora, data, sededrivein, numerosala, sedesala, titolofilm) VALUES ('P00019', '18:00:00', '2013-10-29', NULL, 1, 'SD0004', 'Il Padrino');
INSERT INTO public.proiezione (codiceproiezione, ora, data, sededrivein, numerosala, sedesala, titolofilm) VALUES ('P00020', '19:15:00', '2017-08-13', NULL, 2, 'SD0004', 'Titanic');


--
-- TOC entry 3026 (class 0 OID 322173)
-- Dependencies: 209
-- Data for Name: sala; Type: TABLE DATA; Schema: public; Owner: fdiviest
--

INSERT INTO public.sala (numerosala, sede) VALUES (1, 'SD0002');
INSERT INTO public.sala (numerosala, sede) VALUES (2, 'SD0002');
INSERT INTO public.sala (numerosala, sede) VALUES (3, 'SD0002');
INSERT INTO public.sala (numerosala, sede) VALUES (1, 'SD0003');
INSERT INTO public.sala (numerosala, sede) VALUES (2, 'SD0003');
INSERT INTO public.sala (numerosala, sede) VALUES (3, 'SD0003');
INSERT INTO public.sala (numerosala, sede) VALUES (1, 'SD0004');
INSERT INTO public.sala (numerosala, sede) VALUES (2, 'SD0004');


--
-- TOC entry 3024 (class 0 OID 322145)
-- Dependencies: 207
-- Data for Name: sede; Type: TABLE DATA; Schema: public; Owner: fdiviest
--

INSERT INTO public.sede (codicesede, oraapertura, orachiusura, indirizzo, codicecitta, fatturatototale, tipo) VALUES ('SD0001', '09:00:00', '21:00:00', 'Viale della Libertà 1', 'CIT001', 51, 'driveIn');
INSERT INTO public.sede (codicesede, oraapertura, orachiusura, indirizzo, codicecitta, fatturatototale, tipo) VALUES ('SD0002', '09:30:00', '21:30:00', 'Viale dei Mille 6', 'CIT011', 166, 'multisala');
INSERT INTO public.sede (codicesede, oraapertura, orachiusura, indirizzo, codicecitta, fatturatototale, tipo) VALUES ('SD0003', '09:00:00', '21:00:00', 'Piazza della Repubblica 8', 'CIT005', 115, 'multisala');
INSERT INTO public.sede (codicesede, oraapertura, orachiusura, indirizzo, codicecitta, fatturatototale, tipo) VALUES ('SD0004', '10:15:00', '22:15:00', 'Via Dante Alighieri 10', 'CIT010', 70, 'multisala');
INSERT INTO public.sede (codicesede, oraapertura, orachiusura, indirizzo, codicecitta, fatturatototale, tipo) VALUES ('SD0005', '10:30:00', '23:00:00', 'Via Sicilia 11', 'CIT014', 21, 'driveIn');


--
-- TOC entry 3023 (class 0 OID 322130)
-- Dependencies: 206
-- Data for Name: sottoscrizione; Type: TABLE DATA; Schema: public; Owner: fdiviest
--

INSERT INTO public.sottoscrizione (cfcliente, abbonamento, datainizioutilizzo) VALUES ('BLLFPP03M30C111P', 'A00001', '2003-09-02');
INSERT INTO public.sottoscrizione (cfcliente, abbonamento, datainizioutilizzo) VALUES ('RZZPLZ02F11L205R', 'A00002', '2005-03-23');
INSERT INTO public.sottoscrizione (cfcliente, abbonamento, datainizioutilizzo) VALUES ('SRTGLL98B17C351K', 'A00003', '2011-10-23');
INSERT INTO public.sottoscrizione (cfcliente, abbonamento, datainizioutilizzo) VALUES ('DVSFPP03M02C111P', 'A00001', '2003-09-02');
INSERT INTO public.sottoscrizione (cfcliente, abbonamento, datainizioutilizzo) VALUES ('BNZMRZ85M01C205H', 'A00001', '2003-09-20');
INSERT INTO public.sottoscrizione (cfcliente, abbonamento, datainizioutilizzo) VALUES ('FRNGNN88D10D612F', 'A00003', '2011-10-24');


--
-- TOC entry 2863 (class 2606 OID 322124)
-- Name: abbonamento abbonamento_pkey; Type: CONSTRAINT; Schema: public; Owner: fdiviest
--

ALTER TABLE ONLY public.abbonamento
    ADD CONSTRAINT abbonamento_pkey PRIMARY KEY (codiceabbonamento);


--
-- TOC entry 2878 (class 2606 OID 322226)
-- Name: biglietto biglietto_pkey; Type: CONSTRAINT; Schema: public; Owner: fdiviest
--

ALTER TABLE ONLY public.biglietto
    ADD CONSTRAINT biglietto_pkey PRIMARY KEY (codicebiglietto);


--
-- TOC entry 2855 (class 2606 OID 322093)
-- Name: citta citta_pkey; Type: CONSTRAINT; Schema: public; Owner: fdiviest
--

ALTER TABLE ONLY public.citta
    ADD CONSTRAINT citta_pkey PRIMARY KEY (codicecitta);


--
-- TOC entry 2858 (class 2606 OID 322102)
-- Name: cliente cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: fdiviest
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (cf);


--
-- TOC entry 2861 (class 2606 OID 322113)
-- Name: film film_pkey; Type: CONSTRAINT; Schema: public; Owner: fdiviest
--

ALTER TABLE ONLY public.film
    ADD CONSTRAINT film_pkey PRIMARY KEY (titolo);


--
-- TOC entry 2870 (class 2606 OID 322167)
-- Name: parcheggio parcheggio_pkey; Type: CONSTRAINT; Schema: public; Owner: fdiviest
--

ALTER TABLE ONLY public.parcheggio
    ADD CONSTRAINT parcheggio_pkey PRIMARY KEY (sede, numero);


--
-- TOC entry 2874 (class 2606 OID 322196)
-- Name: poltrona poltrona_pkey; Type: CONSTRAINT; Schema: public; Owner: fdiviest
--

ALTER TABLE ONLY public.poltrona
    ADD CONSTRAINT poltrona_pkey PRIMARY KEY (riga, colonna, numerosala, sedesala);


--
-- TOC entry 2876 (class 2606 OID 322206)
-- Name: proiezione proiezione_pkey; Type: CONSTRAINT; Schema: public; Owner: fdiviest
--

ALTER TABLE ONLY public.proiezione
    ADD CONSTRAINT proiezione_pkey PRIMARY KEY (codiceproiezione);


--
-- TOC entry 2872 (class 2606 OID 322178)
-- Name: sala sala_pkey; Type: CONSTRAINT; Schema: public; Owner: fdiviest
--

ALTER TABLE ONLY public.sala
    ADD CONSTRAINT sala_pkey PRIMARY KEY (sede, numerosala);


--
-- TOC entry 2868 (class 2606 OID 322153)
-- Name: sede sede_pkey; Type: CONSTRAINT; Schema: public; Owner: fdiviest
--

ALTER TABLE ONLY public.sede
    ADD CONSTRAINT sede_pkey PRIMARY KEY (codicesede);


--
-- TOC entry 2865 (class 2606 OID 322134)
-- Name: sottoscrizione sottoscrizione_pkey; Type: CONSTRAINT; Schema: public; Owner: fdiviest
--

ALTER TABLE ONLY public.sottoscrizione
    ADD CONSTRAINT sottoscrizione_pkey PRIMARY KEY (cfcliente, abbonamento);


--
-- TOC entry 2853 (class 1259 OID 322094)
-- Name: citta_nome_provincia_uindex; Type: INDEX; Schema: public; Owner: fdiviest
--

CREATE UNIQUE INDEX citta_nome_provincia_uindex ON public.citta USING btree (nome, provincia);


--
-- TOC entry 2856 (class 1259 OID 322103)
-- Name: cliente_nome_cognome_index; Type: INDEX; Schema: public; Owner: fdiviest
--

CREATE INDEX cliente_nome_cognome_index ON public.cliente USING btree (nome, cognome);


--
-- TOC entry 2859 (class 1259 OID 322114)
-- Name: film_annouscita_index; Type: INDEX; Schema: public; Owner: fdiviest
--

CREATE INDEX film_annouscita_index ON public.film USING btree (annouscita);


--
-- TOC entry 2866 (class 1259 OID 322159)
-- Name: sede_fatturatototale_index; Type: INDEX; Schema: public; Owner: fdiviest
--

CREATE INDEX sede_fatturatototale_index ON public.sede USING btree (fatturatototale);


--
-- TOC entry 2879 (class 2606 OID 322125)
-- Name: abbonamento abbonamento_cfcliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fdiviest
--

ALTER TABLE ONLY public.abbonamento
    ADD CONSTRAINT abbonamento_cfcliente_fkey FOREIGN KEY (cfcliente) REFERENCES public.cliente(cf);


--
-- TOC entry 2889 (class 2606 OID 322232)
-- Name: biglietto biglietto_cfcliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fdiviest
--

ALTER TABLE ONLY public.biglietto
    ADD CONSTRAINT biglietto_cfcliente_fkey FOREIGN KEY (cfcliente) REFERENCES public.cliente(cf);


--
-- TOC entry 2890 (class 2606 OID 322227)
-- Name: biglietto biglietto_codiceproiezione_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fdiviest
--

ALTER TABLE ONLY public.biglietto
    ADD CONSTRAINT biglietto_codiceproiezione_fkey FOREIGN KEY (codiceproiezione) REFERENCES public.proiezione(codiceproiezione);


--
-- TOC entry 2891 (class 2606 OID 322237)
-- Name: biglietto biglietto_numeroparcheggio_sedeparcheggio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fdiviest
--

ALTER TABLE ONLY public.biglietto
    ADD CONSTRAINT biglietto_numeroparcheggio_sedeparcheggio_fkey FOREIGN KEY (numeroparcheggio, sedeparcheggio) REFERENCES public.parcheggio(numero, sede);


--
-- TOC entry 2892 (class 2606 OID 322242)
-- Name: biglietto biglietto_rigaposto_colonnaposto_numerosala_sedesala_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fdiviest
--

ALTER TABLE ONLY public.biglietto
    ADD CONSTRAINT biglietto_rigaposto_colonnaposto_numerosala_sedesala_fkey FOREIGN KEY (rigaposto, colonnaposto, numerosala, sedesala) REFERENCES public.poltrona(riga, colonna, numerosala, sedesala);


--
-- TOC entry 2883 (class 2606 OID 322168)
-- Name: parcheggio parcheggio_sede_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fdiviest
--

ALTER TABLE ONLY public.parcheggio
    ADD CONSTRAINT parcheggio_sede_fkey FOREIGN KEY (sede) REFERENCES public.sede(codicesede);


--
-- TOC entry 2885 (class 2606 OID 322197)
-- Name: poltrona poltrona_numerosala_sedesala_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fdiviest
--

ALTER TABLE ONLY public.poltrona
    ADD CONSTRAINT poltrona_numerosala_sedesala_fkey FOREIGN KEY (numerosala, sedesala) REFERENCES public.sala(numerosala, sede);


--
-- TOC entry 2886 (class 2606 OID 322207)
-- Name: proiezione proiezione_sededrivein_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fdiviest
--

ALTER TABLE ONLY public.proiezione
    ADD CONSTRAINT proiezione_sededrivein_fkey FOREIGN KEY (sededrivein) REFERENCES public.sede(codicesede);


--
-- TOC entry 2887 (class 2606 OID 322217)
-- Name: proiezione proiezione_sedesala_numerosala_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fdiviest
--

ALTER TABLE ONLY public.proiezione
    ADD CONSTRAINT proiezione_sedesala_numerosala_fkey FOREIGN KEY (sedesala, numerosala) REFERENCES public.sala(sede, numerosala);


--
-- TOC entry 2888 (class 2606 OID 322212)
-- Name: proiezione proiezione_titolofilm_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fdiviest
--

ALTER TABLE ONLY public.proiezione
    ADD CONSTRAINT proiezione_titolofilm_fkey FOREIGN KEY (titolofilm) REFERENCES public.film(titolo);


--
-- TOC entry 2884 (class 2606 OID 322179)
-- Name: sala sala_sede_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fdiviest
--

ALTER TABLE ONLY public.sala
    ADD CONSTRAINT sala_sede_fkey FOREIGN KEY (sede) REFERENCES public.sede(codicesede);


--
-- TOC entry 2882 (class 2606 OID 322154)
-- Name: sede sede_codicecitta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fdiviest
--

ALTER TABLE ONLY public.sede
    ADD CONSTRAINT sede_codicecitta_fkey FOREIGN KEY (codicecitta) REFERENCES public.citta(codicecitta);


--
-- TOC entry 2880 (class 2606 OID 322140)
-- Name: sottoscrizione sottoscrizione_abbonamento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fdiviest
--

ALTER TABLE ONLY public.sottoscrizione
    ADD CONSTRAINT sottoscrizione_abbonamento_fkey FOREIGN KEY (abbonamento) REFERENCES public.abbonamento(codiceabbonamento);


--
-- TOC entry 2881 (class 2606 OID 322135)
-- Name: sottoscrizione sottoscrizione_cfcliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fdiviest
--

ALTER TABLE ONLY public.sottoscrizione
    ADD CONSTRAINT sottoscrizione_cfcliente_fkey FOREIGN KEY (cfcliente) REFERENCES public.cliente(cf);


--
-- TOC entry 3035 (class 0 OID 0)
-- Dependencies: 7
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- TOC entry 3036 (class 0 OID 0)
-- Dependencies: 205
-- Name: TABLE abbonamento; Type: ACL; Schema: public; Owner: fdiviest
--

GRANT SELECT,INSERT,REFERENCES,UPDATE ON TABLE public.abbonamento TO fbellon;


--
-- TOC entry 3037 (class 0 OID 0)
-- Dependencies: 212
-- Name: TABLE biglietto; Type: ACL; Schema: public; Owner: fdiviest
--

GRANT SELECT,INSERT,REFERENCES,UPDATE ON TABLE public.biglietto TO fbellon;


--
-- TOC entry 3038 (class 0 OID 0)
-- Dependencies: 202
-- Name: TABLE citta; Type: ACL; Schema: public; Owner: fdiviest
--

GRANT SELECT,INSERT,REFERENCES,UPDATE ON TABLE public.citta TO fbellon;


--
-- TOC entry 3039 (class 0 OID 0)
-- Dependencies: 203
-- Name: TABLE cliente; Type: ACL; Schema: public; Owner: fdiviest
--

GRANT SELECT,INSERT,REFERENCES,UPDATE ON TABLE public.cliente TO fbellon;


--
-- TOC entry 3040 (class 0 OID 0)
-- Dependencies: 204
-- Name: TABLE film; Type: ACL; Schema: public; Owner: fdiviest
--

GRANT SELECT,INSERT,REFERENCES,UPDATE ON TABLE public.film TO fbellon;


--
-- TOC entry 3041 (class 0 OID 0)
-- Dependencies: 208
-- Name: TABLE parcheggio; Type: ACL; Schema: public; Owner: fdiviest
--

GRANT SELECT,INSERT,REFERENCES,UPDATE ON TABLE public.parcheggio TO fbellon;


--
-- TOC entry 3042 (class 0 OID 0)
-- Dependencies: 210
-- Name: TABLE poltrona; Type: ACL; Schema: public; Owner: fdiviest
--

GRANT SELECT,INSERT,REFERENCES,UPDATE ON TABLE public.poltrona TO fbellon;


--
-- TOC entry 3043 (class 0 OID 0)
-- Dependencies: 211
-- Name: TABLE proiezione; Type: ACL; Schema: public; Owner: fdiviest
--

GRANT SELECT,INSERT,REFERENCES,UPDATE ON TABLE public.proiezione TO fbellon;


--
-- TOC entry 3044 (class 0 OID 0)
-- Dependencies: 209
-- Name: TABLE sala; Type: ACL; Schema: public; Owner: fdiviest
--

GRANT SELECT,INSERT,REFERENCES,UPDATE ON TABLE public.sala TO fbellon;


--
-- TOC entry 3045 (class 0 OID 0)
-- Dependencies: 207
-- Name: TABLE sede; Type: ACL; Schema: public; Owner: fdiviest
--

GRANT SELECT,INSERT,REFERENCES,UPDATE ON TABLE public.sede TO fbellon;


--
-- TOC entry 3046 (class 0 OID 0)
-- Dependencies: 206
-- Name: TABLE sottoscrizione; Type: ACL; Schema: public; Owner: fdiviest
--

GRANT SELECT,INSERT,REFERENCES,UPDATE ON TABLE public.sottoscrizione TO fbellon;


-- Completed on 2024-06-03 10:22:11

--
-- PostgreSQL database dump complete
--

