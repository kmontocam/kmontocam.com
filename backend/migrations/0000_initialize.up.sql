CREATE SCHEMA IF NOT EXISTS "home";

DO $$
BEGIN
    CREATE TYPE translations_language_code AS ENUM ('en', 'es');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

CREATE TABLE IF NOT EXISTS "home"."translations" (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
  language_code translations_language_code NOT NULL,
  section VARCHAR NOT NULL,
  content VARCHAR NOT NULL
);

INSERT INTO
  "home"."translations" (language_code, section, content)
VALUES
  ('en', 'nav-section-studies', 'Studies'),
  ('en', 'nav-section-experience', 'Experience'),
  ('en', 'nav-section-friends', 'Friends'),
  (
    'en',
    'nav-languages',
    '<li hx-post="https://api.kmontocam.com/home/v1/language/{code}" hx-vals=''{"code": "en"}'' hx-swap="none" hx-trigger="click" onclick="changeDomLanguage(''en-US''); toggleCollapsedMenu(''toggle-menu'')"><span>English</span></li><li hx-post="https://api.kmontocam.com/home/v1/language/{code}" hx-vals=''{"code": "es"}'' hx-swap="none" hx-trigger="click" onclick="changeDomLanguage(''en-LA''); toggleCollapsedMenu(''toggle-menu'')"><span>Spanish</span></li>'
  ),
  ('en', 'active-language-iso', 'EN'),
  ('en', 'nav-collapsed-title-language', 'Switch Language'),
  ('en', 'home-heading', 'Hello, World!'),
  (
    'en',
    'home-intro',
    'I am <b>Kevin Montoya</b>, a college senior with a keen interest in <span class="underline-data">Data Applications</span>, <span class="underline-swe">Software Engineering</span> and <span class="underline-ai">Artificial Intelligence</span>. I am truly passionate when these domains intersect, but anything involving a technological aspect captivates me.'
  ),
  (
    'en',
    'home-outro',
    'This is my personal web page. Initially was designed with the intention of serving as a portfolio, but as I worked on it, I decided to make it a little more special. Definitely Web Design is not my biggest skill... but this is me trying!'
  ),
  ('en', 'studies-heading', 'Academia'),
  (
    'en',
    'studies-bs-intro',
    '<span class="bs-title">B.S. in Data Science and Mathematics Engineering</span><br>My studies began in August 2020, I anticipate graduating sometime in June 2024.'
  ),
  (
    'en',
    'studies-bs-description',
    'At the home campus in the city of <b>Monterrey</b>, <b>Mexico</b>. I have been involved in several courses that cover a range of subjects, from Data Science: specializing in both Machine Learning and Deep Learning, some Statistical Analysis... All the way to Cryptography and Cybersecurity.'
  ),
  (
    'en',
    'studies-outro',
    'I am deeply enthusiastic about learning, attending school is unique and I would love to keep expanding my academic profile, but I like it better when I put my knowledge into practice and start building ideas.'
  ),
  ('en', 'experience-heading', 'The work I have done'),
  (
    'en',
    'experience-hey-description',
    'Since August 2023, I have been immersed in crafting infrastructure solutions for the Artificial Intelligence department. I designed and developed a complete microservice architecture, built upon Kubernetes in the cloud, featuring GPU-intensive applications and OpenAI solutions with secure connections. Additionally, I have deployed databases and monitoring systems, managing resources using infrastructure as code to handle staging and production environments.'
  ),
  (
    'en',
    'experience-cemex-intro',
    'From February to June 2023, I had to oportunity to participate in an internship with the Processes & IT department at Prague, CZ.'
  ),
  (
    'en',
    'experience-cemex-description',
    'I was responsible of architecting and developing a new cross-selling engine for one of the company''s business lines. I would like to tell you more, but you always have stay to loyal to those papers.'
  ),
  (
    'en',
    'experience-nvim-conda-description',
    'I could not deal with the fact that to change a conda environment inside Neovim I had to restart the editor. I wrote a plugin to solve this in all conda compatible shells. For me, one of the greatest things about software is the culture. I made this project public so others can benefit from it and help me improve this task.'
  ),
  ('en', 'friends-heading', 'Company & Devotion'),
  (
    'en',
    'friends-intro',
    'This is a space for my friends. Today I am surrounded by incredible people who share kindness, passion and talent in what they do. Thank you for having influentiated the way I think, express and create. Learning from each one of you is a gift, and I would always love to keeping doing so.'
  ),
  (
    'en',
    'friends-outro',
    'There are some faces missing! I swear I will make them as soon as possible. I would also like to add my parents, but I am not sure if they would like to be online.'
  ),
  ('en', 'end-heading', 'The end'),
  (
    'en',
    'end-description',
    'Bye for now! Send me a postcard, drop me a line or contact me on the social addresses I listed below if you are interested in anything of which I do. You can always find me in the internet as <b>kmontocam</b> and it will be my pleasure to help and contribute in what I can (or if it is just to talk about some interesting techie stuff, I am always down too).'
  ),
  ('es', 'nav-section-studies', 'Estudios'),
  ('es', 'nav-section-experience', 'Experiencia'),
  ('es', 'nav-section-friends', 'Amigos'),
  (
    'es',
    'nav-languages',
    '<li hx-post="https://api.kmontocam.com/home/v1/language/{code}" hx-vals=''{"code": "en"}'' hx-swap="none" hx-trigger="click" onclick="changeDomLanguage(''en-US''); toggleCollapsedMenu(''toggle-menu'')"><span>Inglés</span></li><li hx-post="https://api.kmontocam.com/home/v1/language/{code}" hx-vals=''{"code": "es"}'' hx-swap="none" hx-trigger="click" onclick="changeDomLanguage(''en-LA''); toggleCollapsedMenu(''toggle-menu'')"><span>Español</span></li>'
  ),
  ('es', 'active-language-iso', 'ES'),
  ('es', 'nav-collapsed-title-language', 'Cambiar Idioma'),
  ('es', 'home-heading', 'Aló'),
  (
    'es',
    'home-intro',
    'Mi nombre es  <b>Kevin Montoya Campaña</b>, voy en cuarto año de carrera y me interesa mucho todo lo que tiene que ver con <span class="underline-data">Aplicaciones de Datos</span>, <span class="underline-swe">  Software</span> e <span class="underline-ai">Inteligencia Artificial</span>. Mi parte favorita es cuando estas tres intersectan, pero cualquier cosa que tenga un aspecto tecnológico me llama la atención.'
  ),
  (
    'es',
    'home-outro',
    'Esta es mi página web. Nació con la intención de servir como portafolio, pero conforme he trabajado en ella tomé la decisión de darle otro giro. Definitivamente el diseño web no es mi mayor virtud, pero he aquí mi intento.'
  ),
  ('es', 'studies-heading', 'Academia'),
  (
    'es',
    'studies-bs-intro',
    '<span class="bs-title">Ingeniería en Ciencia de Datos y Matemáticas</span><br>Empecé la carrera en plena pandemia, espero graduarme en junio de 2024.'
  ),
  (
    'es',
    'studies-bs-description',
    'En la capital del norte, <b>Monterrey</b>, <b>Nuevo León</b>. He cursado múltiples materias que cubren una gran variedad de temas. Desde Ciencia de Datos aplicada para desarrollar modelos de Machine Learning y Deep Learning, materias de Análisis Estadístico, hasta clases de criptografía y seguridad.'
  ),
  (
    'es',
    'studies-outro',
    'Trato de siempre estar aprendiendo algo nuevo, la vida estudiantil es genial y me encantaría seguir trabajando mi carrera académica, pero me gusta más cuando pongo en práctica mis conocimientos y empiezo a construir ideas.'
  ),
  ('es', 'experience-heading', 'Mi trabajo'),
  (
    'es',
    'experience-hey-description',
    'Desde agosto de 2023, he desarrollado la infraestructura y arquitectura de software para el equipo de Inteligencia Artificial. He diseñado e implementado soluciones basadas en microservicios en la nube, utilizando Kubernetes. Esta arquitectura soporta aplicaciones demandantes en GPU, junto con servicios de OpenAI mediante conexiones seguras. Además, he desplegado bases de datos y sistemas de monitoreo, utilizando infraestructura como código para gestionar ámbientes de pruebas y producción.'
  ),
  (
    'es',
    'experience-cemex-intro',
    'De febrero a junio de 2023, tuve la oportunidad de participar en un internship con el equipo de Process & IT en la ciudad de Praga.'
  ),
  (
    'es',
    'experience-cemex-description',
    'Durante la estancia, fui responsable de diseñar la arquitectura de un modelo para venta cruzada. Me gustaría elaborar más, pero uno debe permanecer fiel a lo que firma en esos papeles.'
  ),
  (
    'es',
    'experience-nvim-conda-description',
    'No podía lidiar con que para cambiar un ambiente de conda dentro de Neovim era necesario reiniciar el editor. Escribí un plugin para resolver esto en todas las shells compatibles con conda. Para mí, la bondad más grande del software está en su cultura, hice este proyecto público para que otros puedan contribuir y solucionar este problema.'
  ),
  ('es', 'friends-heading', 'Querida Compañía'),
  (
    'es',
    'friends-intro',
    'Este es un espacio para mis amigos. Hoy me encuentro rodeado de gente increíble que comparte simpatía, pasión y talento por lo que hace. Gracias por influenciar la manera en que pienso, comunico e invento. Aprender de cada uno de ustedes es un regalo que me encantaría continuar desenvolviendo muchos días más.'
  ),
  (
    'es',
    'friends-outro',
    '¡Faltan caras! Las estaré añadiendo lo antes posible. También me gustaría agregar a mis padres, pero no estoy seguro si simpaticen con la idea de estar en línea.'
  ),
  ('es', 'end-heading', 'Fin'),
  (
    'es',
    'end-description',
    '¡Hasta Luego! Contáctame en cualquiera de los medios sociales listados abajo si estás interesado en algo de lo que hago. Siempre puedes encontrarme en el internet como <b>kmontocam</b> y yo estaré encantado de ayudar y contribuir en lo que pueda (o si es solo para hablar sobre algo casual o tecnológico, no dudes en hacerlo).'
  );
