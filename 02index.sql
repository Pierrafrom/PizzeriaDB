 -- Index for the table ADDRESS because we will use it in the WHERE clause many times
CREATE INDEX idx_latitude ON ADDRESS(latitude);
CREATE INDEX idx_longitude ON ADDRESS(longitude);
