select p.filename photo_name, c.name cat_name
from photos p, categories_photos cp, categories c
where p.id = cp.photo_id
and cp.category_id = c.id;

