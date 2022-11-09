insert into buildhooks (
    buildhook_uid,
    status_id,
    user_uid,
    site_uid,
    label,
    org_uid,
    env
) values (
    uuid(),
    2,
    uuid(),
    uuid(),
    'test1',
    uuid(),
    'sandbox'
), (
    uuid(),
    2,
    uuid(),
    uuid(),
    'test2',
    uuid(),
    'prod'
), (
    uuid(),
    2,
    uuid(),
    uuid(),
    'test3',
    uuid(),
    'staging'
);
