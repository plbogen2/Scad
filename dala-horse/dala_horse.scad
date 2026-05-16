pattern = "dala_horse.svg";

/* [Hidden] */
IN = 25.4;

linear_extrude(4) {
    offset(10) {
        minkowski() {
            import(pattern);
        } 
    }
}

linear_extrude(1 * IN)
    difference() {
        offset(2) {
            minkowski() {
                import(pattern);
            }
        }
        import(pattern);
    }