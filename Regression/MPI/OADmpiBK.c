#include <malloc.h>
#include <string.h>
#include "mpi.h"

struct rBufAssoc { 
  void * addr; 
  void * taddr;
  int length;
  int req;
}; 

struct sBufAssoc { 
  void * addr;
  int length;
  int req;
}; 

static struct rBufAssoc rBufAssoc_p[100];
static struct sBufAssoc sBufAssoc_p[100];

static int rBufAssocIndex=0;
static int sBufAssocIndex=0;

/* 
 combine temporary buffer allocation 
 and bookkeeping
*/
void oadtirecv_(void *buf,
		int *count, 
		int *datatype, 
		int *src, 
		int *tag, 
		int *comm, 
		int *req, 
		int *ierror) {
  double * tBuf; 
  tBuf=malloc(*count*sizeof(double));
  *ierror = MPI_Irecv( tBuf, 
		       *count, 
		       (MPI_Datatype)(*datatype), 
		       *src, 
		       *tag, 
		       (MPI_Comm)(*comm), 
		       (MPI_Request *)(req));
  printf("irecv b:%x t:%x c:%i r:%i\n",buf,(void*)tBuf,*count, *req);
  rBufAssoc_p[rBufAssocIndex].addr=buf;
  rBufAssoc_p[rBufAssocIndex].taddr=(void*)tBuf;
  rBufAssoc_p[rBufAssocIndex].length=*count;
  rBufAssoc_p[rBufAssocIndex].req=*req;
  rBufAssocIndex+=1;
} 

/* 
 combine temporary buffer allocation 
 and bookkeeping
*/
void oadtisend_(void *buf,
		int *count, 
		int *datatype, 
		int *dest, 
		int *tag, 
		int *comm, 
		int *req, 
		int *ierror) {
  *ierror = MPI_Isend( buf, 
		       *count, 
		       (MPI_Datatype)(*datatype), 
		       *dest, 
		       *tag, 
		       (MPI_Comm)(*comm), 
		       (MPI_Request *)(req));
  printf("isend b:%x c:%i r:%i\n",buf,*count, *req);
  sBufAssoc_p[sBufAssocIndex].addr=buf;
  sBufAssoc_p[sBufAssocIndex].length=*count;
  sBufAssoc_p[sBufAssocIndex].req=*req;
  sBufAssocIndex+=1;
} 

void oadhandlerequest_ (int *r) { 
  int done=0;
  double *tBuf;
  double *rBuf;
  int i,j;
  for(i=0; i<sBufAssocIndex; i++) { 
    if (*r==sBufAssoc_p[i].req) { 
      memset(sBufAssoc_p[i].addr,0,
	     sBufAssoc_p[i].length*sizeof(double));
      done=1;
      break; 
    }
  }
  if (done)
    return;
  for(i=0; i<rBufAssocIndex; i++) { 
    if (*r==rBufAssoc_p[i].req) { 
      tBuf=(double *)rBufAssoc_p[i].taddr;
      rBuf=(double *)rBufAssoc_p[i].addr;
      for(j=0;j<rBufAssoc_p[i].length;j++) { 
	rBuf[i]+=tBuf[i];
      }
      free(tBuf);
      break; 
    }
  }
}
