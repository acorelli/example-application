[:link: αΩ-###: JIRA Issue Title](JIRA Issue URL)  
  
-----  
```    
Description from JIRA issue  
```
    
------  

```  
Any additional description text goes here 
```

-----  
-----  

Builds must pass the [Jenkins](http://url.to.the.jenkins.server:8080/job/example-product/job/example-module/) build pipeline.  
  
to build with [Jenkins](http://url.to.the.jenkins.server:8080/job/example-product/job/example-module/)  
post `jenkins please try a build`  
down in the comments  
  
-----  
-----  

**Developer Checklist:**  
-----  
- [ ] Doxygen comments  
- [ ] Unit tests (if applicable)  
- [ ] Fix merge conflicts w/ target branch  
- [ ] Update `title` and `description` fields of this merge request  
- [ ] Assign to a reviewer that (_ideally_) did not write code in this request  
- [ ] :warning: Check the `Remove source branch when merge request is accepted.` and `Squash commits when merge request is accepted.` checkboxes on the `New Merge Request`/`Edit Merge Request` page  
  
**Reviewer Checklist:**  
-----  
- [ ] Review code  
- [ ] Review [:link: Jenkins build/test results](http://url.to.the.jenkins.server:8080/job/example-product/job/example-module/)  
- [ ] Review [:link: cppcheck findings](http://url.to.the.jenkins.server:8080/job/example-product/job/example-module/)  
- [ ] Review merge request Title/Description  
- [ ] :warning: Verify that the merge/squash commit message is of the form: `αΩ-###: JIRA Issue Title`  
  
  
/wip  
/assign me  
