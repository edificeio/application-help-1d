#!/usr/bin/env groovy

pipeline {
  agent any
    stages {
      stage('Build') {
        steps {
          sh '''
            rm -rf application-help-1d.tar.gz application assets help-1d
          '''
          checkout scm
          sh '''
            for app in `find ./application -type f -name '*.md' | cut -d. -f2 | cut -d'/' -f3 | cat`; 
            do
                mkdir "application/$app"
                # remove the ".gitbook" prefix for images path in markdown files
                sed -i -E 's/(!\\[.*\\]\\(<?)\\.gitbook/\\1/g' application/${app}.md
                sed -i '1d' application/${app}.md
                sed -i -e '/{%.*%}/d' application/${app}.md
                sed -i 's/\\(##.*\\){#.*}/\\1/g' application/${app}.md
                docker-compose run --rm pandoc -s --toc --section-divs -f markdown -t html /application/${app}.md -o /application/${app}/index.html
                echo "Processed $app"
            done
            mv application/collaborative-editor application/collaborativeeditor
            mv application/scrap-book application/scrapbook
            cp -Rf application/.gitbook/assets .
            rm -Rf application/*.md application/.gitbook
            mkdir help-1d && mv application assets help-1d 
            tar cfzh application-help-1d.tar.gz help-1d conf.j2
	        '''
        }
      }
      stage('Publish') {
        steps {
          sh '''
            VERSION=`grep 'version=' VERSION | sed 's/version=//'`
            case "$VERSION" in
              *SNAPSHOT) nexusRepository='snapshots' ;;
              *)         nexusRepository='releases' ;;
            esac
            mvn deploy:deploy-file -DgroupId=com.opendigitaleducation -DartifactId=application-help-1d -Dversion=$VERSION -Dpackaging=tar.gz -Dfile=application-help-1d.tar.gz -DrepositoryId=wse -Durl=https://maven.opendigitaleducation.com/nexus/content/repositories/$nexusRepository/
          '''
        }
      }
    }
}

