CREATE OR REPLACE PROCEDURE createLanguage(
	id int,
	name varchar,
	code varchar)
AS $$
declare
-- variable declaration
begin
	INSERT into language (id, name, code) values(id, name, code);
	commit;
end; 
$$ LANGUAGE 'plpgsql';



CREATE OR REPLACE FUNCTION createContent(
	lang_id int,
	text TEXT) returns integer AS $$
declare
	res_id integer;
begin
	INSERT into text_content (orig_text, orig_lang_id) values(text, lang_id) returning id INTO res_id;
	return res_id;
end; 
$$ LANGUAGE 'plpgsql';