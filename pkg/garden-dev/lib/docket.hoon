/-  *docket
|%
::
++  mime
  |%
  +$  draft
    $:  title=(unit @t)
        info=(unit @t)
        color=(unit @ux)
        glob-http=(unit url)
        glob-ames=(unit =ship)
        base=(unit term)
        site=(unit path)
        image=(unit url)
        version=(unit version)
        website=(unit url)
        license=(unit cord)
    ==
  ::
  ++  finalize
    |=  =draft
    ^-  (unit docket)
    ?~  title.draft  ~
    ?~  info.draft  ~
    ?~  color.draft  ~
    ?~  version.draft  ~
    ?~  website.draft  ~
    ?~  license.draft  ~
    =/  href=(unit href)
      ?^  site.draft  `[%site u.site.draft]
      ?~  base.draft  ~
      ?^  glob-http.draft
        `[%glob [u.base %http u.glob-http]:draft]
      ?~  glob-ames.draft
        ~
      `[%glob [u.base %ames u.glob-ames]:draft]
    ?~  href  ~
    =,  draft
    :-  ~
    :*  %1
        u.title
        u.info
        u.color
        u.href
        image
        u.version
        u.website
        u.license
    ==
  ::
  ++  from-clauses
    =|  =draft
    |=  cls=(list clause)
    ^-  (unit docket)
    =*  loop  $
    ?~  cls  (finalize draft)
    =*  clause  i.cls
    =.  draft
      ?-  -.clause
        %title  draft(title `title.clause)
        %info   draft(info `info.clause)
        %color  draft(color `color.clause)
        %glob-http   draft(glob-http `url.clause)
        %glob-ames   draft(glob-ames `ship:clause)
        %base   draft(base `base.clause)
        %site   draft(site `path.clause)
        %image  draft(image `url.clause)
        %version  draft(version `version.clause)
        %website  draft(website `website.clause)
        %license  draft(license `license.clause)
      ==
    loop(cls t.cls)
  ::
  ++  to-clauses
    |=  d=docket
    ^-  (list clause)
    %-  zing
    :~  :~  title+title.d
            info+info.d
            color+color.d
            version+version.d
            website+website.d
            license+license.d
        ==
        ?~  image.d  ~  ~[image+u.image.d]
        ?:  ?=(%site -.href.d)  ~[site+path.href.d]
        =/  loc=glob-location  glob-location.href.d
        :~  base+base.href.d
            ?-  -.loc
              %http  [%glob-http url.loc]
              %ames  [%glob-ames ship.loc]
    ==  ==  ==
  ::
  ++  spit-clause
    |=  =clause
    ^-  tape
    %+  weld  "  {(trip -.clause)}+"
    ?+  -.clause  "'{(trip +.clause)}'"
      %color  (scow %ux color.clause)
      %site   (spud path.clause)
      %glob-ames  (scow %p ship.clause)
      ::
        %version
      =,  version.clause
      "[{(scow %ud major)} {(scow %ud minor)} {(scow %ud patch)}]"
    ==
  ::
  ++  spit-docket
    |=  dock=docket
    ^-  tape
    ;:  welp
      ":~\0a"
      `tape`(zing (join "\0a" (turn (to-clauses dock) spit-clause)))
      "\0a=="
    ==
  --
::
++  enjs
  =,  enjs:format
  |%
  ::
  ++  charge-update
    |=  u=^charge-update
    ^-  json
    %+  frond  -.u
    ^-  json
    ?-  -.u
      %del-charge  s+desk.u
    ::
        %initial  
      %-  pairs
      %+  turn  ~(tap by initial.u)
      |=([=desk c=^charge] [desk (charge c)]) 
    ::
        %add-charge
      %-  pairs
      :~  desk+s+desk.u
          charge+(charge charge.u)
      ==
    ==
  ::
  ++  num
    |=  a=@u
    ^-  ^tape
    =/  p=json  (numb a)
    ?>  ?=(%n -.p)
    (trip p.p)
  ::
  ++  version
    |=  v=^version
    ^-  json
    :-  %s
    %-  crip
    "{(num major.v)}.{(num minor.v)}.{(num patch.v)}"
  ::
  ++  merge
    |=  [a=json b=json]
    ^-  json
    ?>  &(?=(%o -.a) ?=(%o -.b))
    [%o (~(uni by p.a) p.b)]
  ::
  ++  href
    |=  h=^href
    %+  frond  -.h
    ?-    -.h
        %site  s+(spat path.h)
        %glob
      %-  pairs
      :~  base+s+base.h
          glob-location+(glob-location glob-location.h)
      ==
    ==
  ::
  ++  glob-location
    |=  loc=^glob-location
    ^-  json
    %+  frond  -.loc
    ?-  -.loc
      %http  (pairs url+s+url.loc ~)
      %ames  (ship ship.loc)
    ==
  ::
  ++  charge
    |=  c=^charge
    %+  merge  (docket docket.c)
    %-  pairs
    :~  chad+(chad chad.c)
    ==
  ::
  ++  docket
    |=  d=^docket
    ^-  json
    %-  pairs
    :~  title+s+title.d
        info+s+info.d
        color+s+(scot %ux color.d)
        href+(href href.d)
        image+?~(image.d ~ s+u.image.d)
        version+(version version.d)
        license+s+license.d
        website+s+website.d
    ==
  ::
  ++  chad
    |=  c=^chad
    %+  frond  -.c
    ?+  -.c  ~
      %hung  s+err.c
    ==
  --
--