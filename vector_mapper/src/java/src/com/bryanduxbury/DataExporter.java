package com.bryanduxbury;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import org.geotools.data.DataStore;
import org.geotools.data.DataStoreFinder;
import org.geotools.data.FeatureSource;
import org.geotools.feature.FeatureCollection;
import org.geotools.feature.FeatureIterator;
import org.opengis.feature.Feature;
import org.opengis.geometry.Geometry;

public class DataExporter {

  public static void main(String[] args) {
    File file = new File("mayshapefile.shp");

    try {
      Map connect = new HashMap();
      connect.put("url", file.toURL());

      DataStore dataStore = DataStoreFinder.getDataStore(connect);
      String[] typeNames = dataStore.getTypeNames();
      String typeName = typeNames[0];

      System.out.println("Reading content " + typeName);

      FeatureSource featureSource = dataStore.getFeatureSource(typeName);
      FeatureCollection collection = featureSource.getFeatures();
      FeatureIterator iterator = collection.features();


      try {
        while (iterator.hasNext()) {
          Feature feature = iterator.next();
          Geometry sourceGeometry = feature.getDefaultGeometry();
        }
      } finally {
        iterator.close();
      }

    } catch (Throwable e) {}
  }

}
