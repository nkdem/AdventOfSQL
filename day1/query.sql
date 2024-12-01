SELECT wish_lists.name, wish_lists.primary_wish, wish_lists.backup_wish, wish_lists.favorite_color,  
wish_lists.color_count,
(
    CASE WHEN toy_catalogue.difficulty_to_make = 1
    THEN 'Simple Gift'
    ELSE CASE WHEN toy_catalogue.difficulty_to_make = 2
    THEN 'Moderate Gift'
    ELSE 'Complex Gift'
    END
    END
) AS gift_complexity,
(
    CASE WHEN toy_catalogue.category = 'outdoor' 
    THEN 'Outside Workshop'
    ELSE CASE WHEN toy_catalogue.category = 'educational'
    THEN 'Learning Workshop'
    ELSE 'General Workshop'
    END
    END
)
FROM toy_catalogue
INNER JOIN 
(SELECT children.name, REPLACE(((((wishes->>'colors')::jsonb)->0)::text),'"','') AS favorite_color,
jsonb_array_length((wishes->>'colors')::jsonb) AS color_count,
wishes->>'first_choice' AS primary_wish,
wishes->>'second_choice' AS backup_wish
FROM wish_lists
INNER JOIN children ON wish_lists.child_id = children.child_id
) AS wish_lists ON toy_catalogue.toy_name = wish_lists.primary_wish
ORDER BY wish_lists.name ASC