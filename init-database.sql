-- Enable PostGIS extensions
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS postgis_topology;
CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;

-- Create sample table for testing
CREATE TABLE IF NOT EXISTS sample_features (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    geom GEOMETRY(Geometry, 4326),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create spatial index
CREATE INDEX idx_sample_features_geom ON sample_features USING GIST (geom);

-- Insert sample data
INSERT INTO sample_features (name, description, geom) VALUES
('Point 1', 'Sample point feature', ST_GeomFromText('POINT(-74.006 40.7128)', 4326)),
('Point 2', 'Another sample point', ST_GeomFromText('POINT(-73.985 40.7589)', 4326)),
('Line 1', 'Sample line feature', ST_GeomFromText('LINESTRING(-74.006 40.7128, -73.985 40.7589)', 4326)),
('Polygon 1', 'Sample polygon feature', ST_GeomFromText('POLYGON((-74.01 40.71, -74.00 40.71, -74.00 40.72, -74.01 40.72, -74.01 40.71))', 4326))
ON CONFLICT DO NOTHING;