pipeline {
  agent {
    docker {
      image 'node:latest'
    }

  }
  stages {
    stage('npm install') {
      steps {
        sh 'npm install -g hexo-cli'
        sh 'npm install'
      }
    }
    stage('mv dev') {
      when {
        branch 'dev'
      }
      steps {
        sh 'mv -f _config.dev.yml _config.yml'
      }
    }
    stage('build') {
      steps {
        sh 'hexo clean'
        sh 'hexo generate'
        sh 'git remote -v'
        sh 'git branch -v -a'
        sh 'git tag'
        sh 'sh ./checkout-branch.sh'
      }
    }
    stage('dev-release') {
      when {
        branch 'dev'
      }
      steps {
        sh 'ls'
        sh 'git tag'
        sh 'git remote -v'
        sh 'git branch -v -a'
        sh 'git checkout --orphan dev-blog'
      }
    }
    stage('master-release') {
      when {
        branch 'master'
      }
      steps {
        sh 'ls'
        sh 'git tag'
        sh 'git remote -v'
        sh 'git branch -v -a'
        sh 'git checkout --orphan gh-pages'
      }
    }
    stage('release-common') {
      steps {
        sh 'git status'
        sh 'git config user.name "${BITBUCKET_WRITE_USERNAME}"'
        sh 'git config user.email "${BITBUCKET_WRITE_EMAIL}" '
        sh 'git branch -v -a'
        sh 'git status'
        sh 'git rm --cached -r -f .'
        sh 'rm -rf `ls | grep -v public`'
        sh 'cp -r ./public/* .'
        sh 'rm -rf ./public'
        sh 'git add -f .'
        sh 'git status'
        sh 'git commit -m "Auto Release `date +"%Y-%m-%d %H:%M:%S"`"'
        sh 'git status'
      }
    }
    stage('dev') {
      when {
        branch 'dev'
      }
      steps {
        sh 'git push -f https://${CODING_USERNAME}:${CODING_PASSWD}@e.coding.net/spiritling/dev.git'
      }
    }
    stage('master') {
      when {
        branch 'master'
      }
      steps {
        sh 'git push -f https://${GITHUB_USERNAME}:${GITHUB_PASSWD}@github.com/SpiritLing/blog.git'
      }
    }
    stage('build tar And Send Master') {
      when {
        branch 'master'
      }
      steps {
        sh 'tar -zcvf ./dist-backup-`date +"%Y-%m-%d-%H-%M-%S"`.tar.gz --exclude=./.git ./*'
        emailext(subject: '${EMAIL_TITLE_DEFAULT}', body: '${EMAIL_NOTICE_DEFAULT}', mimeType: 'text/html', replyTo: '${EMAIL_SONG}', to: '${EMAIL_SHOU}', attachmentsPattern: 'dist-backup-*')
      }
    }
    stage('send Dev email') {
      when {
        branch 'dev'
      }
      steps {
        emailext(subject: '${EMAIL_TITLE_DEFAULT}', body: '${EMAIL_NOTICE_DEFAULT}', mimeType: 'text/html', replyTo: '${EMAIL_SONG}', to: '${EMAIL_SHOU}')
      }
    }
    stage('Finish') {
      steps {
        cleanWs(cleanWhenNotBuilt: true, cleanWhenFailure: true, cleanWhenSuccess: true, cleanWhenUnstable: true, deleteDirs: true)
      }
    }
  }
}