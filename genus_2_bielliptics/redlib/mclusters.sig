178,0
T,ClM,-,0
A,ClM,28,Sigma,index,parentindex,size,rootcls,v,dv,lambda,min,bv,ev,nuv,nv,mv,tv,pv,sv,gammav,delta,pv0,sv0,gammav0,lv,vtilde,cv0,uv,g,ubereven
T,ClPicM,-,0
A,ClPicM,10,D,K,F,v,k,p,f,g,s,C
S,IsCoercible,Coerce a MacLane-Muselli cluster,0,2,0,0,0,0,0,0,0,-1,,0,0,ClM,,36,-1,-38,-38,-38,-38
S,in,"""in"" function for a MacLane-Muselli cluster",0,2,0,0,0,0,0,0,0,-1,,0,0,ClM,,36,-38,-38,-38,-38,-38
S,Print,Print a MacLane-Muselli cluster,0,2,0,0,1,0,0,0,0,298,,0,0,ClM,,-38,-38,-38,-38,-38,-38
S,#,Size of a MacLane-Muselli cluster = number of roots inside,0,1,0,0,0,0,0,0,0,ClM,,148,-38,-38,-38,-38,-38
S,Degree,Degree of a MacLane-Muselli cluster = degree of the defining valuation,0,1,0,0,0,0,0,0,0,ClM,,148,-38,-38,-38,-38,-38
S,Valuation,Valuation that cuts out the cluster,0,1,0,0,0,0,0,0,0,ClM,,148,-38,-38,-38,-38,-38
S,ClusterPicture,Cluster picture in which the cluster s lives,0,1,0,0,0,0,0,0,0,ClM,,ClPicM,-38,-38,-38,-38,-38
S,Index,Index of the cluster in the cluster picture,0,1,0,0,0,0,0,0,0,ClM,,148,-38,-38,-38,-38,-38
S,eq,Equality testing for MacLane-Muselli clusters in the same cluster picture,0,2,0,0,0,0,0,0,0,ClM,,0,0,ClM,,36,-38,-38,-38,-38,-38
S,IsProperSubset,"True if s is properly contained in p (for s,p MacLane-Muselli clusters)",0,2,0,0,0,0,0,0,0,ClM,,0,0,ClM,,36,-38,-38,-38,-38,-38
S,Children,Proper children of a MacLane-Muselli cluster,0,1,0,0,0,0,0,0,0,ClM,,82,-38,-38,-38,-38,-38
S,ParentCluster,Parent of a MacLane-Muselli cluster,0,1,0,0,0,0,0,0,0,ClM,,ClM,-38,-38,-38,-38,-38
S,RootClusters,List of root cluster valuations contained in the MacLane-Muselli cluster s,0,1,0,0,0,0,0,0,0,ClM,,82,-38,-38,-38,-38,-38
S,IsCoercible,Coerce a MacLane-Muselli cluster picture,0,2,0,0,0,0,0,0,0,-1,,0,0,ClPicM,,36,-1,-38,-38,-38,-38
S,in,"""in"" function for a MacLane-Muselli cluster picture",0,2,0,0,0,0,0,0,0,-1,,0,0,ClPicM,,36,-38,-38,-38,-38,-38
S,Print,Print a MacLane-Muselli cluster picture,0,2,0,0,1,0,0,0,0,298,,0,0,ClPicM,,-38,-38,-38,-38,-38,-38
S,#,Total size of a MacLane-Muselli cluster picture,0,1,0,0,0,0,0,0,0,ClPicM,,148,-38,-38,-38,-38,-38
S,Genus,Genus of a MacLane-Muselli cluster picture,0,1,0,0,0,0,0,0,0,ClPicM,,148,-38,-38,-38,-38,-38
S,BaseField,Original base field K for a MacLane-Muselli cluster picture,0,1,0,0,0,0,0,0,0,ClPicM,,-24,-38,-38,-38,-38,-38
S,ResidueField,Residue field k of the base field K over which a MacLane-Muselli cluster picture is defined,0,1,0,0,0,0,0,0,0,ClPicM,,-24,-38,-38,-38,-38,-38
S,FieldOfDefinition,Unramified extension F of the base field K of a MacLane-Muselli cluster picture over which the centers are defined,0,1,0,0,0,0,0,0,0,ClPicM,,-24,-38,-38,-38,-38,-38
S,Clusters,List of all clusters (of type ClM) that form the cluster picture,0,1,0,0,0,0,0,0,0,ClPicM,,82,-38,-38,-38,-38,-38
S,RootClusters,"Construct S := MacLane valuations (<-> improper root clusters) for a polynomial f over a DVR.  These correspond to factors of f over the unramfied closure of the completion of K.  When f is irreducible over it, such a MacLane valuation is unique, and it is the truncation  of the unique pseudo-valuation that f->infty at the last step of its MacLane presentation.  This function may change D and f if an unramified base extension is needed along the way",0,3,0,0,1,0,0,1,1,-38,,1,1,312,,1,1,RngDVR,,-38,-38,-38,-38,-38,-38
S,ClusterPicture,Construct a MacLane-Muselli cluster picture for a hyperelliptic curve y^2=f(x) defined over a discrete valued field (RngDVR) of residue characteristic not 2,0,2,0,0,0,0,0,0,0,RngDVR,,0,0,312,,ClPicM,-38,-38,-38,-38,-38
S,DualGraph,Returns the dual graph of a special fibre of a regular model with normal crossings constructed from a MacLane-Muselli cluster picture (Muselli's Theorem). Two optional flags: check: test multiplicities (default true); contract: contract components to get minimal r.n.c. model (default true);,0,1,0,0,0,0,0,0,0,ClPicM,,GrphDual,-38,-38,-38,-38,-38
S,TeX,List of clusters as an TeX array,0,1,0,0,0,0,0,0,0,ClPicM,,298,-38,-38,-38,-38,-38
S,MuselliModel,MacLane-Muselli model with normal crossings of a hyperelliptic curve y^2=f(x) defined over a discretely valued field (RngDVR) of residue characteristic not 2,0,2,0,0,0,0,0,0,0,RngDVR,,0,0,312,,CrvModel,-38,-38,-38,-38,-38
