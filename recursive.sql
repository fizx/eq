WITH RECURSIVE 
children(activity_id) AS (
    VALUES(#{initial_id})
  UNION
    SELECT id FROM activities WHERE parent_id = activity_id
),
ancestors(activity_id) AS (
    VALUES(#{initial_id})
  UNION
    SELECT parent_id FROM activitites WHERE id = activity_id
),
relations AS (children UNION ancestors)

SELECT * FROM relations;